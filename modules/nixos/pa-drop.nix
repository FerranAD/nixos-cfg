{ pkgs, config, ... }:

{
  services.openssh = {
    extraConfig = ''
      Match User pa-drop
        ChrootDirectory /srv/pa-drop
        ForceCommand internal-sftp -d /upload
        PasswordAuthentication no
        KbdInteractiveAuthentication no
        PermitTTY no
        AllowTcpForwarding no
        AllowAgentForwarding no
        X11Forwarding no
    '';
  };

  users.groups.pa-drop = { };

  users.users.pa-drop = {
    isNormalUser = true;
    group = "pa-drop";
    home = "/";
    createHome = false;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7MKiUjqFxzYvLZKYT+c1AuHo3COl2PxpXe/lIwGtvlKyaCJbNI4Q6ujAKgvBqKi+gkLA1OlDF/9ztjM5ODTFcP3Sn4/Y9THNp1oJnBGhdoNrXD/VNl+tyLDdBUOo6uIji+M2UaD8fx1U/MrzGxe8XL4QK044MucfFDRJKClLdOcmHGLg5rz11gyKfa1S6Q7x7PEoPIMgbBtg+uOJoRfynp/izQBKuZvwbC3pVd7sv9OphV9GCm8zLdTT4YdRAjo5vwmuYVSY1Nqh8SntirXL0v8owjjn2SFMCRwXDXqeJGKg8WNUSTFsCfQU0/+YGZTXDWvUpyuZ76oHu5R9noOFMrNKGSoSEKTWdaenviqK37v7GiI7ThVV+d8WGeCNOnuXDotguvBWA+aPPXVl+nTggteQVSWUppWIdrVZ48XCWvE71sUeNxgI32mreBfd53Kacd4y2V8J05i7hEsiURnCgE7ZP0YxqJQOWPd9iusKETyE2Xpl5u72fAkRzo1Q8WqM= sadeh@sadeh01"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/pa-drop 0755 root root -"
    "d /srv/pa-drop/upload 0700 pa-drop pa-drop -"
  ];

  systemd.services.pa-forward = {
    description = "Forward Excel workbooks to PCP";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    path = [
      pkgs.curl
      pkgs.coreutils
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "pa-drop";

      LoadCredential = "pcp-token:${config.age.secrets."pcp-upload-token".path}";

      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    script = ''
      set -euo pipefail

      FILE="/srv/pa-drop/upload/budgets.xlsx"
      ENDPOINT="https://pcp.sadeh.udl.cat/api/v1/imports/workbook"

      TOKEN="$(cat "$CREDENTIALS_DIRECTORY/pcp-token")"

      if [[ ! -f "$FILE" || -L "$FILE" ]]; then
        echo "ERROR: Workbook not found: $FILE" >&2
        exit 1
      fi

      echo "Starting PCP workbook import..."
      echo "Workbook: $FILE"

      if response=$(
        printf 'header = "Authorization: Bearer %s"\n' "$TOKEN" |
        curl \
          --config - \
          --silent \
          --show-error \
          --fail-with-body \
          --connect-timeout 15 \
          --max-time 300 \
          --form "file=@$FILE;filename=budgets.xlsx;type=application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" \
          "$ENDPOINT"
      ); then
        echo "PCP import successful."
        echo "API response: $response"
        echo "Workbook retained on Oracle."
      else
        echo "ERROR: PCP import failed." >&2
        echo "API response: $response" >&2
        exit 1
      fi
    '';
  };

  systemd.timers.pa-forward = {
    description = "Import workbooks every night at 03:00";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 03:00:00 Europe/Madrid";
      Persistent = true;
      AccuracySec = "1s";
    };
  };
}
