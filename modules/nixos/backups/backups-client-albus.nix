{
  config,
  pkgs,
  ...
}:
{
  services.borgbackup.jobs.albus = {
    paths = [
      "/home/ferran"
      "/etc/nixos"
      "/var/lib/tailscale"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
    ];

    exclude = [
      # Largest cache dirs
      ".cache"
      "*/cache2" # firefox
      "*/Cache"
      ".config/Slack/logs"
      ".config/Code/CachedData"
      ".container-diff"
      ".npm/_cacache"

      # Desktop trash folders
      "*/.Trash-*"

      # Standard XDG application cache
      "*/.cache"

      # Rootless Docker images, layers, and build caches
      # Keeps Docker volumes because they may contain databases or other state
      "*/.local/share/docker/overlay2"
      "*/.local/share/docker/image"
      "*/.local/share/docker/buildkit"
      "*/.local/share/docker/tmp"
      "*/.local/share/docker/containers/*/*-json.log"

      # Chromium/Electron application caches
      # Applies to VS Code, VSCodium, Slack, Signal, and similar applications
      "*/.config/*/Cache"
      "*/.config/*/Code Cache"
      "*/.config/*/GPUCache"
      "*/.config/*/DawnWebGPUCache"
      "*/.config/*/DawnGraphiteCache"
      "*/.config/*/CachedData"
      "*/.config/*/CachedProfilesData"
      "*/.config/*/CachedConfigurations"
      "*/.config/*/CachedExtensionVSIXs"
      "*/.config/*/Service Worker/CacheStorage"
      "*/.config/*/Service Worker/ScriptCache"
      "*/.config/*/Crashpad"
      "*/.config/*/logs"
      "*/.config/*/blob_storage"

      # Vesktop stores its Chromium caches one level deeper
      # Keeps settings, themes, cookies, and local application data
      "*/.config/vesktop/sessionData/Cache"
      "*/.config/vesktop/sessionData/Code Cache"
      "*/.config/vesktop/sessionData/GPUCache"
      "*/.config/vesktop/sessionData/DawnWebGPUCache"
      "*/.config/vesktop/sessionData/DawnGraphiteCache"
      "*/.config/vesktop/sessionData/Service Worker/CacheStorage"
      "*/.config/vesktop/sessionData/Service Worker/ScriptCache"
      "*/.config/vesktop/sessionData/blob_storage"

      # Firefox crash reports, telemetry, and diagnostic dumps
      # Keeps bookmarks, history, passwords, extensions, cookies, and site data
      "*/.mozilla/firefox/Crash Reports"
      "*/.mozilla/firefox/Pending Pings"
      "*/.mozilla/firefox/*/minidumps"
      "*/.mozilla/firefox/*/crashes"
      "*/.mozilla/firefox/*/datareporting"
      "*/.mozilla/firefox/*/saved-telemetry-pings"

      # Thunderbird crash reports, telemetry, and diagnostic dumps
      # Keeps local mail, IMAP caches, calendars, address books, and encryption keys
      "*/.thunderbird/Crash Reports"
      "*/.thunderbird/Pending Pings"
      "*/.thunderbird/*/minidumps"
      "*/.thunderbird/*/crashes"
      "*/.thunderbird/*/datareporting"
      "*/.thunderbird/*/saved-telemetry-pings"

      # Zotero diagnostic crash data
      # Keeps the Zotero database and approximately 1 GiB attachment library
      "*/.zotero/zotero/*/minidumps"
      "*/.zotero/zotero/*/crashes"

      # Codex temporary files, caches, and diagnostic logs
      # Keeps sessions, memories, history, skills, plugins, and configuration
      "*/.codex/.tmp"
      "*/.codex/tmp"
      "*/.codex/cache"
      "*/.codex/log"

      # VirtualBox
      "*/VirtualBox VMs/*"

      # JavaScript and frontend dependencies
      "*/node_modules"
      "*/bower_components"

      # Python virtual environments
      # These currently account for approximately 58 GiB
      "*/.venv"
      "*/venv"
      "*/.tox"
      "*/.nox"

      # Python bytecode and development-tool caches
      "*/__pycache__"
      "*/.pytest_cache"
      "*/.mypy_cache"
      "*/.ruff_cache"
      "*/.hypothesis"
      "*/.ipynb_checkpoints"
      "*/*.pyc"
      "*/*.pyo"

      # Terraform-downloaded providers, modules, locks, and plans
      # Keeps terraform.tfstate, terraform.tfstate.backup, and .terraform.lock.hcl
      "*/.terraform"
      "*/.terraform.tfstate.lock.info"
      "*/tfplan"
      "*/tfplan.*"

      # Gradle and Maven downloaded dependencies
      # Maven settings.xml is retained by excluding only the repository
      "*/projects/*/.gradle"
      "*/.gradle/caches"
      "*/.gradle/daemon"
      "*/.gradle/native"
      "*/.gradle/notifications"
      "*/.gradle/wrapper/dists"
      "*/.m2/repository"

      # Kotlin, Android native, and test-emulator caches
      # Deliberately does not exclude ~/.android, which may contain signing keys
      "*/.kotlin"
      "*/.cxx"
      "*/.externalNativeBuild"
      "*/.robolectric"

      # Frontend framework caches and generated working directories
      "*/.angular"
      "*/.astro"
      "*/.next"
      "*/.nuxt"
      "*/.svelte-kit"
      "*/.parcel-cache"
      "*/.vite"
      "*/.turbo"
      "*/.nx"

      # Test coverage reports and generated coverage data
      "*/htmlcov"
      "*/coverage"
      "*/.coverage"
      "*/.coverage.*"
      "*/coverage.xml"
      "*/coverage.json"

      # Documentation and notebook build caches
      "*/.quarto"

      # Temporary operating-system and editor files
      "*/.DS_Store"
      "*/Thumbs.db"
      "*/desktop.ini"
      "*/.~lock.*#"
      "*/*~"

      # Reproducible project build and package outputs
      # Remove this group if final artifacts exist only in these directories
      "*/build"
      "*/_build"
      "*/dist"
      "*/target"
      "*/out"
    ];

    repo = "borg@rubeus:.";

    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borgbackups-passkey.path}";
    };

    environment.BORG_RSH = "${pkgs.openssh}/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -F /dev/null -i ${config.age.secrets.borgbackups-albus-key.path}";

    # Every 10 minutes creates a checkpoint so backups can be interrupted and don't have to start all over again.
    extraCreateArgs = "--verbose --stats --checkpoint-interval 600";

    extraPruneArgs = "--stats";

    compression = "auto,zstd";

    startAt = "hourly";

    # Run a missed backup after boot.
    persistentTimer = true;

    # Do not suspend halfway through a backup.
    inhibitsSleep = true;

    prune.keep = {
      within = "1d"; # keep every backup created during the last 24 hours.
      daily = 7; # keep the newest backup from each of the latest 7 days that contain backups.
      weekly = 4; # keep the newest backup from each of the latest 4 weeks.
      monthly = 6; # keep the newest backup from each of the latest 6 months.
      yearly = 2; # keep the newest backup from each of the latest 2 years.
    };
    # Important note: days containing backups are not necessarily calendar days. If your laptop is off for three days, those missing days do not consume daily retention slots.
  };
}
