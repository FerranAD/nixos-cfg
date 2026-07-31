{ config, lib, pkgs, ... }:
let
  cfg = config.services.borgStatusUi;

  repoInventory = lib.mapAttrsToList (name: repo: {
    inherit name;
    path = toString repo.path;
    quota = repo.quota;
    authorizedKeyCount = builtins.length repo.authorizedKeys;
    appendOnlyKeyCount = builtins.length repo.authorizedKeysAppendOnly;
    allowSubRepos = repo.allowSubRepos;
  }) config.services.borgbackup.repos;

  repoServiceNames =
    lib.mapAttrsToList (name: _: "borgbackup-repo-${name}.service") config.services.borgbackup.repos;

  repoConfig = pkgs.writeText "borg-status-repos.json" (builtins.toJSON {
    freshnessWarningHours = cfg.freshnessWarningHours;
    freshnessCriticalHours = cfg.freshnessCriticalHours;
    repos = repoInventory;
  });

  collector = pkgs.writeText "borg-status-collector.py" ''
    import argparse
    import datetime as dt
    import fnmatch
    import json
    import os
    import shutil
    import subprocess
    import tempfile
    import time

    CONFIG = "${repoConfig}"
    STATE_DIR = "${cfg.stateDir}"
    STATUS_PATH = os.path.join(STATE_DIR, "status.json")
    BORG = "${lib.getExe config.services.borgbackup.package}"

    def utc_now():
        return dt.datetime.now(dt.timezone.utc)

    def iso(ts):
        if ts is None:
            return None
        return dt.datetime.fromtimestamp(ts, dt.timezone.utc).isoformat()

    def human_bytes(value):
        units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB"]
        size = float(value)
        for unit in units:
            if size < 1024 or unit == units[-1]:
                return f"{size:.1f} {unit}" if unit != "B" else f"{int(size)} B"
            size /= 1024

    def load_existing():
        try:
            with open(STATUS_PATH) as fh:
                return json.load(fh)
        except Exception:
            return {}

    def load_config():
        with open(CONFIG) as fh:
            return json.load(fh)

    def newest_transaction(path):
        patterns = ("index.*", "hints.*", "integrity.*", "config")
        newest = None
        matched = []
        try:
            for entry in os.scandir(path):
                if not entry.is_file():
                    continue
                if any(fnmatch.fnmatch(entry.name, pattern) for pattern in patterns):
                    mtime = entry.stat().st_mtime
                    matched.append(entry.name)
                    newest = mtime if newest is None else max(newest, mtime)
        except FileNotFoundError:
            return None, []
        except PermissionError:
            return None, []
        return newest, sorted(matched)

    def fallback_newest(path):
        newest = None
        try:
            for root, dirs, files in os.walk(path):
                dirs[:] = [d for d in dirs if d not in ("lock.exclusive", "tmp")]
                for name in files:
                    try:
                        mtime = os.stat(os.path.join(root, name)).st_mtime
                    except OSError:
                        continue
                    newest = mtime if newest is None else max(newest, mtime)
        except OSError:
            return None
        return newest

    def repo_size(path):
        try:
            result = subprocess.run(
                ["${pkgs.coreutils}/bin/du", "-sb", path],
                check=True,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=120,
            )
            return int(result.stdout.split()[0])
        except Exception:
            total = 0
            try:
                for root, dirs, files in os.walk(path):
                    for name in files:
                        try:
                            total += os.stat(os.path.join(root, name)).st_size
                        except OSError:
                            pass
            except OSError:
                return None
            return total

    def disk_usage(path):
        target = path if os.path.exists(path) else os.path.dirname(path)
        try:
            usage = shutil.disk_usage(target)
        except OSError:
            return None
        used = usage.total - usage.free
        free_percent = (usage.free / usage.total * 100) if usage.total else None
        state = "ok"
        if free_percent is not None and free_percent < 10:
            state = "critical"
        elif free_percent is not None and free_percent < 20:
            state = "warning"
        return {
            "totalBytes": usage.total,
            "usedBytes": used,
            "freeBytes": usage.free,
            "freePercent": free_percent,
            "total": human_bytes(usage.total),
            "used": human_bytes(used),
            "free": human_bytes(usage.free),
            "state": state,
        }

    def freshness(last_write, warning_hours, critical_hours):
        if last_write is None:
            return {"state": "unknown", "ageHours": None}
        age_hours = (time.time() - last_write) / 3600
        if age_hours > critical_hours:
            state = "critical"
        elif age_hours > warning_hours:
            state = "stale"
        else:
            state = "fresh"
        return {"state": state, "ageHours": age_hours}

    def run_check(path):
        started = time.time()
        command = [BORG, "check", "--repository-only", "--lock-wait", "5", path]
        try:
            result = subprocess.run(
                command,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=${toString cfg.checkTimeoutSeconds},
            )
            state = "ok" if result.returncode == 0 else "error"
            return {
                "state": state,
                "exitCode": result.returncode,
                "checkedAt": utc_now().isoformat(),
                "durationSeconds": time.time() - started,
                "message": (result.stderr or result.stdout).strip()[-4000:],
            }
        except subprocess.TimeoutExpired as exc:
            return {
                "state": "timeout",
                "exitCode": None,
                "checkedAt": utc_now().isoformat(),
                "durationSeconds": time.time() - started,
                "message": f"borg check timed out after {exc.timeout} seconds",
            }

    def collect_repo(repo, existing, mode, warning_hours, critical_hours):
        path = repo["path"]
        exists = os.path.isdir(path)
        newest, transaction_files = newest_transaction(path)
        if newest is None and exists:
            newest = fallback_newest(path)
        size_bytes = repo_size(path) if exists else None
        item = {
            **repo,
            "exists": exists,
            "sizeBytes": size_bytes,
            "size": human_bytes(size_bytes) if size_bytes is not None else None,
            "lastRepositoryWrite": iso(newest),
            "transactionFiles": transaction_files,
            "freshness": freshness(newest, warning_hours, critical_hours),
            "disk": disk_usage(path),
            "check": existing.get("check", {"state": "unknown"}),
        }
        if mode == "check" and exists:
            item["check"] = run_check(path)
        return item

    def write_status(data):
        os.makedirs(STATE_DIR, exist_ok=True)
        fd, tmp = tempfile.mkstemp(prefix="status.", suffix=".json", dir=STATE_DIR)
        with os.fdopen(fd, "w") as fh:
            json.dump(data, fh, indent=2, sort_keys=True)
            fh.write("\n")
        os.chmod(tmp, 0o644)
        os.replace(tmp, STATUS_PATH)

    def main():
        parser = argparse.ArgumentParser()
        parser.add_argument("--mode", choices=["cheap", "check"], required=True)
        args = parser.parse_args()

        config = load_config()
        existing = load_existing()
        existing_repos = {repo["name"]: repo for repo in existing.get("repos", [])}
        repos = [
            collect_repo(
                repo,
                existing_repos.get(repo["name"], {}),
                args.mode,
                config["freshnessWarningHours"],
                config["freshnessCriticalHours"],
            )
            for repo in config["repos"]
        ]
        data = {
            "generatedAt": utc_now().isoformat(),
            "mode": args.mode,
            "freshnessWarningHours": config["freshnessWarningHours"],
            "freshnessCriticalHours": config["freshnessCriticalHours"],
            "repos": repos,
        }
        write_status(data)

    if __name__ == "__main__":
        main()
  '';

  server = pkgs.writeText "borg-status-server.py" ''
    import html
    import json
    import os
    import datetime as dt
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

    STATUS_PATH = "${cfg.stateDir}/status.json"
    HOST = "${cfg.listenAddress}"
    PORT = ${toString cfg.port}

    def load_status():
        try:
            with open(STATUS_PATH) as fh:
                return json.load(fh)
        except Exception as exc:
            return {
                "generatedAt": None,
                "repos": [],
                "error": str(exc),
            }

    def fmt(value, suffix=""):
        if value is None:
            return "unknown"
        if isinstance(value, float):
            return f"{value:.1f}{suffix}"
        return f"{value}{suffix}"

    def esc(value):
        return html.escape(str(value), quote=True)

    def format_time(value):
        if not value:
            return "unknown"
        try:
            parsed = dt.datetime.fromisoformat(value)
        except ValueError:
            return str(value)
        if parsed.tzinfo is None:
            parsed = parsed.replace(tzinfo=dt.timezone.utc)
        parsed = parsed.astimezone()
        return parsed.strftime("%b %-d, %Y, %H:%M %Z")

    def time_tag(value):
        if not value:
            return "unknown"
        return f'<time datetime="{esc(value)}" title="{esc(value)}">{esc(format_time(value))}</time>'

    def page(data):
        repos = data.get("repos", [])
        cards = []
        for repo in repos:
            freshness = repo.get("freshness", {})
            check = repo.get("check", {})
            disk = repo.get("disk") or {}
            state = freshness.get("state", "unknown")
            check_state = check.get("state", "unknown")
            disk_state = disk.get("state", "unknown")
            cards.append(f"""
              <article class="repo-card">
                <header>
                  <div>
                    <h2>{esc(repo.get("name", "unknown"))}</h2>
                    <p>{esc(repo.get("path", ""))}</p>
                  </div>
                  <span class="badge {esc(state)}">{esc(state)}</span>
                </header>
                <dl>
                  <div><dt>Size</dt><dd>{esc(repo.get("size") or "unknown")}</dd></div>
                  <div><dt>Last repository write</dt><dd>{time_tag(repo.get("lastRepositoryWrite"))}</dd></div>
                  <div><dt>Age</dt><dd>{esc(fmt(freshness.get("ageHours"), "h"))}</dd></div>
                  <div><dt>Repo check</dt><dd><span class="badge {esc(check_state)}">{esc(check_state)}</span></dd></div>
                  <div><dt>Checked at</dt><dd>{time_tag(check.get("checkedAt"))}</dd></div>
                  <div><dt>Check duration</dt><dd>{esc(fmt(check.get("durationSeconds"), "s"))}</dd></div>
                  <div><dt>Disk free</dt><dd><span class="badge {esc(disk_state)}">{esc(fmt(disk.get("freePercent"), "%"))}</span> {esc(disk.get("free", ""))}</dd></div>
                  <div><dt>Quota</dt><dd>{esc(repo.get("quota") or "none")}</dd></div>
                  <div><dt>SSH keys</dt><dd>{esc(repo.get("authorizedKeyCount", 0))} full, {esc(repo.get("appendOnlyKeyCount", 0))} append-only</dd></div>
                </dl>
                {f'<pre>{esc(check.get("message"))}</pre>' if check.get("message") else ""}
              </article>
            """)

        return f"""<!doctype html>
        <html lang="en">
        <head>
          <meta charset="utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <meta name="robots" content="noindex,nofollow" />
          <title>Rubeus Backups</title>
          <style>
            :root {{
              color-scheme: dark;
              --bg: #080b12;
              --panel: #121721;
              --panel-2: #161d29;
              --text: #edf2f7;
              --muted: #9ca3af;
              --border: #2a3342;
              --ok: #22c55e;
              --warn: #f59e0b;
              --bad: #ef4444;
              --unknown: #94a3b8;
              font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            }}
            * {{ box-sizing: border-box; }}
            body {{
              margin: 0;
              min-height: 100vh;
              color: var(--text);
              background: var(--bg);
            }}
            main {{
              width: min(1180px, calc(100% - 32px));
              margin: 0 auto;
              padding: 32px 0 48px;
            }}
            .topbar {{
              display: flex;
              justify-content: space-between;
              gap: 16px;
              align-items: end;
              margin-bottom: 24px;
            }}
            h1, h2, p {{ margin: 0; }}
            h1 {{ font-size: 2rem; letter-spacing: 0; }}
            .topbar p {{ color: var(--muted); margin-top: 8px; }}
            .api-link {{
              color: var(--text);
              text-decoration: none;
              border: 1px solid var(--border);
              border-radius: 8px;
              padding: 9px 12px;
              background: var(--panel);
            }}
            .grid {{
              display: grid;
              grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
              gap: 16px;
            }}
            .repo-card {{
              border: 1px solid var(--border);
              border-radius: 8px;
              background: var(--panel);
              padding: 18px;
            }}
            .repo-card header {{
              display: flex;
              align-items: start;
              justify-content: space-between;
              gap: 12px;
              padding-bottom: 14px;
              border-bottom: 1px solid var(--border);
            }}
            h2 {{ font-size: 1.15rem; }}
            .repo-card header p {{
              color: var(--muted);
              margin-top: 4px;
              overflow-wrap: anywhere;
            }}
            dl {{
              display: grid;
              gap: 10px;
              margin: 16px 0 0;
            }}
            dl div {{
              display: grid;
              grid-template-columns: 9.5rem 1fr;
              gap: 12px;
            }}
            dt {{ color: var(--muted); }}
            dd {{ margin: 0; overflow-wrap: anywhere; }}
            .badge {{
              display: inline-flex;
              align-items: center;
              min-height: 1.6rem;
              padding: 0 0.55rem;
              border-radius: 999px;
              border: 1px solid var(--unknown);
              color: var(--unknown);
              background: rgba(148, 163, 184, 0.12);
              font-size: 0.8rem;
              font-weight: 700;
              text-transform: uppercase;
            }}
            .fresh, .ok {{ color: var(--ok); border-color: var(--ok); background: rgba(34, 197, 94, 0.12); }}
            .stale, .warning, .timeout {{ color: var(--warn); border-color: var(--warn); background: rgba(245, 158, 11, 0.12); }}
            .critical, .error {{ color: var(--bad); border-color: var(--bad); background: rgba(239, 68, 68, 0.12); }}
            pre {{
              margin: 16px 0 0;
              padding: 12px;
              overflow: auto;
              border-radius: 8px;
              border: 1px solid var(--border);
              background: var(--panel-2);
              color: var(--muted);
              white-space: pre-wrap;
            }}
            @media (max-width: 700px) {{
              main {{ width: min(100% - 20px, 1180px); padding-top: 20px; }}
              .topbar {{ display: block; }}
              .api-link {{ display: inline-block; margin-top: 14px; }}
              dl div {{ grid-template-columns: 1fr; gap: 3px; }}
            }}
          </style>
        </head>
        <body>
          <main>
            <section class="topbar">
              <div>
                <h1>Rubeus Backups</h1>
                <p>Server-side Borg repository health. Generated at {time_tag(data.get("generatedAt"))}.</p>
              </div>
              <a class="api-link" href="/api/status">JSON</a>
            </section>
            <section class="grid">
              {"".join(cards) if cards else '<article class="repo-card"><h2>No repositories found</h2></article>'}
            </section>
          </main>
        </body>
        </html>"""

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, format, *args):
            return

        def do_GET(self):
            if self.path == "/api/status":
                data = load_status()
                body = json.dumps(data, indent=2, sort_keys=True).encode()
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Cache-Control", "no-store")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)
                return
            if self.path in ("/", "/index.html"):
                body = page(load_status()).encode()
                self.send_response(200)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.send_header("Cache-Control", "no-store")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)
                return
            self.send_error(404)

    if __name__ == "__main__":
        ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
  '';
in
{
  options.services.borgStatusUi = {
    enable = lib.mkEnableOption "read-only Borg repository status UI";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8090;
      description = "Port for the Borg status UI.";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address for the Borg status UI to listen on.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/borg-status-ui";
      description = "Directory containing cached status JSON.";
    };

    freshnessWarningHours = lib.mkOption {
      type = lib.types.int;
      default = 36;
      description = "Hours after which a repository is marked stale.";
    };

    freshnessCriticalHours = lib.mkOption {
      type = lib.types.int;
      default = 72;
      description = "Hours after which a repository is marked critical.";
    };

    checkTimeoutSeconds = lib.mkOption {
      type = lib.types.int;
      default = 3300;
      description = "Timeout for repository-only Borg checks.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.borg-status-ui = {
      isSystemUser = true;
      group = "borg-status-ui";
    };
    users.groups.borg-status-ui = { };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 borg borg -"
    ];

    systemd.services.borg-status-ui-refresh = {
      description = "Refresh cheap Borg repository status";
      after = repoServiceNames;
      serviceConfig = {
        Type = "oneshot";
        User = "borg";
        Group = "borg";
        StateDirectory = "borg-status-ui";
        StateDirectoryMode = "0755";
        ExecStart = "${lib.getExe pkgs.python3} ${collector} --mode cheap";
      };
    };

    systemd.services.borg-status-ui-check = {
      description = "Run Borg repository-only status checks";
      after = repoServiceNames;
      serviceConfig = {
        Type = "oneshot";
        User = "borg";
        Group = "borg";
        StateDirectory = "borg-status-ui";
        StateDirectoryMode = "0755";
        ExecStart = "${lib.getExe pkgs.python3} ${collector} --mode check";
      };
    };

    systemd.timers.borg-status-ui-refresh = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "15m";
        Persistent = true;
      };
    };

    systemd.timers.borg-status-ui-check = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "1h";
        Persistent = true;
      };
    };

    systemd.services.borg-status-ui = {
      description = "Read-only Borg repository status UI";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "borg-status-ui-refresh.service" ];
      wants = [ "borg-status-ui-refresh.service" ];
      serviceConfig = {
        Type = "simple";
        User = "borg-status-ui";
        Group = "borg-status-ui";
        ExecStart = "${lib.getExe pkgs.python3} ${server}";
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadOnlyPaths = [ cfg.stateDir ];
      };
    };
  };
}
