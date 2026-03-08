{...}:
{
  services.homepage-dashboard = {
    enable = true;

    allowedHosts = "dobby:8082";
    listenPort = 8082;

    settings = {
      title = "Dobby";
      description = "Homeserver dashboard";
      theme = "dark";
      color = "slate";

      layout = {
        Home = {
          style = "row";
          columns = 3;
        };
      };
    };

    bookmarks = [
      {
        Developer = [
          {
            Github = [
              {
                abbr = "GH";
                href = "https://github.com";
              }
            ];
          }
          {
            NixOS = [
              {
                abbr = "NX";
                href = "https://search.nixos.org";
              }
            ];
          }
        ];
      }
    ];

    widgets = [
      {
        resources = {
          uptime = true;
          cpu = true;
          cputemp = true;
          memory = true;
          disk = "/";
          units = "metric";
          network = "enp86s0";
        };
      }

      {
        datetime = {
          text_size = "xl";
          format = "dddd, DD MMMM HH:mm";
        };
      }
    ];
  };

  services.glances.enable = true;
}