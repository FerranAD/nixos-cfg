{
  config,
  pkgs,
  ...
}:
{
  services.borgbackup.jobs.laptop = {
    paths = [
      # "/home/ferran/data"
      # "/home/ferran/projects"
      "/home/ferran/test"
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
      # Work related dirs
      "*/node_modules"
      "*/bower_components"
      "*/_build"
      "*/.tox"
      "*/venv"
      "*/.venv"
    ];

    repo = "borg@rubeus:.";

    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borgbackups-passkey.path}";
    };

    environment.BORG_RSH = "${pkgs.openssh}/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -F /dev/null -i ${config.age.secrets.borgbackups-albus-key.path}";

    compression = "auto,zstd";

    startAt = "daily";

    # Run a missed backup after boot.
    persistentTimer = true;

    # Do not suspend halfway through a backup.
    inhibitsSleep = true;

    prune.keep = {
      within = "1d"; # keep every backup created during the last 24 hours.
      daily = 7; # keep the newest backup from each of the latest 7 days that contain backups.
      weekly = 4; # keep the newest backup from each of the latest 4 weeks.
      monthly = 6; # keep the newest backup from each of the latest 6 months.
      yearly = 2;# keep the newest backup from each of the latest 2 years.
    };
    # Important note: days containing backups are not necessarily calendar days. If your laptop is off for three days, those missing days do not consume daily retention slots.
  };
}
