{
  config,
  pkgs,
  ...
}:
let
  homepageDashboard = pkgs.homepage-dashboard.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace src/components/widgets/search/search.jsx \
        --replace-fail 'import { FiSearch } from "react-icons/fi";' \
                       'import { FiGithub, FiPackage, FiSearch } from "react-icons/fi";'

      substituteInPlace src/components/widgets/search/search.jsx \
        --replace-fail '  custom: {' '  github: {
    name: "GitHub",
    url: "https://github.com/search?q=",
    icon: FiGithub,
  },
  nixpkgs: {
    name: "Nixpkgs Issues",
    url: "https://github.com/NixOS/nixpkgs/issues?q=",
    icon: FiPackage,
  },
  custom: {'
    '';
  });
in
{
  services.homepage-dashboard = {
    package = homepageDashboard;
    environmentFiles = [ config.age.secrets."homepage-dashboard.env".path ];
    enable = true;
    allowedHosts = "home.aranferran.com,dobby,dobby:8082,localhost,localhost:8082,127.0.0.1,127.0.0.1:8082";
    listenPort = 8082;

    settings = {
      title = "Dobby";
      description = "Home page for my home lab!";
      startUrl = "https://home.aranferran.com";
      language = "en";
      theme = "dark";
      color = "slate";
      headerStyle = "clean";
      iconStyle = "theme";
      fullWidth = true;
      target = "_blank";
      statusStyle = "dot";
      useEqualHeights = true;
      hideVersion = true;
      disableUpdateCheck = true;
      disableIndexing = true;

      quicklaunch = {
        provider = "github";
        searchDescriptions = true;
        showSearchSuggestions = false;
        mobileButtonPosition = "bottom-right";
      };

      layout = [
        {
          "Library" = {
            style = "row";
            columns = 3;
            icon = "mdi-bookshelf";
          };
        }
        {
          "Tools" = {
            style = "row";
            columns = 2;
            icon = "mdi-tools";
          };
        }
        {
          "Services" = {
            style = "row";
            columns = 5;
            icon = "mdi-apps";
          };
        }
        {
          "Servarr" = {
            style = "row";
            columns = 4;
            icon = "mdi-movie-open-cog-outline";
          };
        }
        {
          "Infrastructure" = {
            style = "row";
            columns = 3;
            icon = "mdi-server-network";
          };
        }
      ];
    };

    widgets = [
      {
        glances = {
          url = "https://glances.aranferran.com";
          version = 4;
          label = "dobby";
          cpu = true;
          mem = true;
          cputemp = true;
          uptime = true;
          disk = "/";
          expanded = true;
        };
      }
      {
        search = {
          provider = [
            "github"
            "nixpkgs"
          ];
          focus = true;
          showSearchSuggestions = false;
          target = "_blank";
        };
      }
      {
        openmeteo = {
          label = "Lleida";
          latitude = 41.61674;
          longitude = 0.62218;
          timezone = config.time.timeZone;
          units = "metric";
          cache = 5;
          format.maximumFractionDigits = 1;
        };
      }
      {
        datetime = {
          text_size = "xl";
          locale = "en-GB";
          format = {
            dateStyle = "medium";
            timeStyle = "short";
            hourCycle = "h23";
          };
        };
      }
    ];

    services = [
      {
        "Servarr" = [
          {
            "Jellyfin" = {
              id = "dobby-jellyfin";
              icon = "jellyfin.png";
              href = "https://jellyfin.aranferran.com";
              description = "Movies and series";
              siteMonitor = "http://127.0.0.1:8096";
              widget = {
                type = "jellyfin";
                url = "http://127.0.0.1:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                enableBlocks = true;
                enableNowPlaying = true;
                fields = [ "movies" "series" "episodes" ];
              };
            };
          }
          {
            "Jellyseerr" = {
              id = "dobby-jellyseerr";
              icon = "jellyseerr.png";
              href = "https://jellyseerr.aranferran.com";
              description = "Request movies and series";
              siteMonitor = "http://127.0.0.1:${toString config.services.jellyseerr.port}";
              widget = {
                type = "seerr";
                url = "http://127.0.0.1:${toString config.services.jellyseerr.port}";
                key = "{{HOMEPAGE_VAR_SEERR_API_KEY}}";
                fields = [ "pending" "approved" "issues" ];
              };
            };
          }
          {
            "Sonarr" = {
              id = "dobby-sonarr";
              icon = "sonarr.png";
              href = "https://sonarr.aranferran.com";
              description = "Series";
              siteMonitor = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
              widget = {
                type = "sonarr";
                url = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
                key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                fields = [ "wanted" "queued" "series" ];
              };
            };
          }
          {
            "Radarr" = {
              id = "dobby-radarr";
              icon = "radarr.png";
              href = "https://radarr.aranferran.com";
              description = "Movies";
              siteMonitor = "http://localhost:${toString config.services.radarr.settings.server.port}";
              widget = {
                type = "radarr";
                url = "http://localhost:${toString config.services.radarr.settings.server.port}";
                key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                fields = [ "wanted" "queued" "movies" ];
              };
            };
          }
          {
            "Bazarr" = {
              id = "dobby-bazarr";
              icon = "bazarr.png";
              href = "https://bazarr.aranferran.com";
              description = "Subtitles";
              siteMonitor = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";
              widget = {
                type = "bazarr";
                url = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";
                key = "{{HOMEPAGE_VAR_BAZARR_API_KEY}}";
                fields = [ "missingEpisodes" "missingMovies" ];
              };
            };
          }
          {
            "Prowlarr" = {
              id = "dobby-prowlarr";
              icon = "prowlarr.png";
              href = "https://prowlarr.aranferran.com";
              description = "Indexer";
              siteMonitor = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
              widget = {
                type = "prowlarr";
                url = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
                key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
                fields = [ "numberOfGrabs" "numberOfQueries" "numberOfFailQueries" ];
              };
            };
          }
          {
            "Transmission" = {
              id = "dobby-transmission";
              icon = "transmission.png";
              href = "https://transmission.aranferran.com";
              description = "Torrents";
              siteMonitor = "https://transmission.aranferran.com";
              widget = {
                type = "transmission";
                url = "http://127.0.0.1:${toString config.services.transmission.settings.rpc-port}";
                rpcUrl = "/transmission/";
                fields = [ "leech" "download" "seed" "upload" ];
              };
            };
          }
          {
            "FlareSolverr" = {
              id = "dobby-flaresolverr";
              icon = "flaresolverr.png";
              href = "https://flaresolverr.aranferran.com";
              description = "Browser challenge solver for indexers";
              siteMonitor = "http://127.0.0.1:${toString config.services.flaresolverr.port}";
            };
          }
        ];
      }
      {
        "Library" = [
          {
            "Immich" = {
              id = "dobby-immich";
              icon = "immich.png";
              href = "https://immich.aranferran.com";
              description = "Photo and video archive";
              siteMonitor = "http://localhost:${toString config.services.immich.port}";
              widget = {
                type = "immich";
                url = "http://localhost:${toString config.services.immich.port}";
                key = "{{HOMEPAGE_VAR_IMMICH_API_KEY}}";
                version = 2;
                fields = [ "photos" "videos" "storage" ];
              };
            };
          }
          {
            "Trilium" = {
              id = "dobby-trilium";
              icon = "trilium.png";
              href = "https://trilium.aranferran.com";
              description = "Notes";
              siteMonitor = "http://127.0.0.1:${toString config.services.trilium-server.port}";
            };
          }
          {
            "Shiori" = {
              id = "dobby-shiori";
              icon = "shiori.png";
              href = "https://shiori.aranferran.com";
              description = "Bookmarks";
              siteMonitor = "http://127.0.0.1:${toString config.services.shiori.port}";
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "Ollama" = {
              id = "dobby-ollama";
              icon = "ollama.png";
              href = "https://ollama.aranferran.com";
              description = "Qwen3 (4binstruct-2507-q8_0)";
              siteMonitor = "http://127.0.0.1:${toString config.services.ollama.port}/api/tags";
            };
          }
          {
            "Xikibby Minecraft" = {
              id = "rowling-minecraft-xikibby";
              icon = "minecraft.png";
              description = "Minecraft server on Rowling · port 5501";
              widget = {
                type = "minecraft";
                url = "udp://privatebin.oracle.aranferran.com:5501";
                fields = [ "status" "players" "version" ];
              };
            };
          }
          {
            "Pofnet Minecraft" = {
              id = "rowling-minecraft-pofnet";
              icon = "minecraft.png";
              description = "Minecraft server on Rowling · port 5502";
              widget = {
                type = "minecraft";
                url = "udp://privatebin.oracle.aranferran.com:5502";
                fields = [ "status" "players" "version" ];
              };
            };
          }
          {
            "Vikunja" = {
              id = "rowling-vikunja";
              icon = "vikunja.png";
              href = "https://vikunja-xikibby.oracle.aranferran.com";
              description = "TODOs for Míriam on Rowling.";
              siteMonitor = "https://vikunja-xikibby.oracle.aranferran.com";
            };
          }
          {
            "Nextcloud" = {
              id = "rowling-nextcloud";
              icon = "nextcloud.png";
              href = "https://cloud.oracle.aranferran.com";
              description = "Files and collaboration for pofnet on Rowling";
              siteMonitor = "https://cloud.oracle.aranferran.com";
            };
          }
        ];
      }
      {
        "Tools" = [
          {
            "Freemarg" = {
              id = "dobby-freemarg";
              icon = "mdi-hiking";
              href = "https://freemarg.aranferran.com";
              description = "Free margalef";
              siteMonitor = "http://127.0.0.1:8881";
            };
          }
          {
            "PrivateBin" = {
              id = "rowling-privatebin";
              icon = "privatebin.png";
              href = "https://privatebin.oracle.aranferran.com";
              description = "Private pastebin on Rowling";
              siteMonitor = "https://privatebin.oracle.aranferran.com";
            };
          }
        ];
      }
      {
        "Infrastructure" = [
          {
            "Dobby Traefik" = {
              id = "dobby-traefik";
              icon = "traefik.png";
              href = "https://traefik.aranferran.com";
              description = "Reverse proxy on Dobby";
              siteMonitor = "https://traefik.aranferran.com";
              widget = {
                type = "traefik";
                url = "https://traefik.aranferran.com";
                fields = [ "routers" "services" "middleware" ];
              };
            };
          }
          {
            "Rowling Traefik" = {
              id = "rowling-traefik";
              icon = "traefik.png";
              href = "https://traefik.oracle.aranferran.com";
              description = "Reverse proxy on Rowling";
              siteMonitor = "https://traefik.oracle.aranferran.com";
              widget = {
                type = "traefik";
                url = "https://traefik.oracle.aranferran.com";
                fields = [ "routers" "services" "middleware" ];
              };
            };
          }
          {
            "Glances" = {
              id = "dobby-glances";
              icon = "glances.png";
              href = "https://glances.aranferran.com";
              description = "Dobby stats";
              siteMonitor = "http://127.0.0.1:${toString config.services.glances.port}";
            };
          }
        ];
      }
    ];

    customCSS = ''
      :root {
        --dobby-border: rgba(148, 163, 184, 0.16);
        --dobby-surface: rgba(15, 23, 42, 0.68);
        --dobby-surface-hover: rgba(30, 41, 59, 0.82);
        --host-dobby: rgba(34, 211, 238, 0.9);
        --host-dobby-soft: rgba(8, 145, 178, 0.2);
        --host-rowling: rgba(192, 132, 252, 0.9);
        --host-rowling-soft: rgba(147, 51, 234, 0.2);
      }

      body {
        min-height: 100vh;
        background-color: #05070d !important;
        background-image:
          radial-gradient(circle at 12% 12%, rgba(99, 102, 241, 0.22), transparent 32rem),
          radial-gradient(circle at 88% 18%, rgba(34, 211, 238, 0.14), transparent 30rem),
          radial-gradient(circle at 50% 100%, rgba(168, 85, 247, 0.12), transparent 36rem),
          linear-gradient(145deg, #05070d 0%, #0b1022 48%, #111827 100%) !important;
        background-attachment: fixed !important;
      }

      #page_container {
        max-width: 1800px;
        margin: 0 auto;
        padding-top: 1.5rem;
      }

      .service-card,
      .bookmark-card {
        border: 1px solid var(--dobby-border) !important;
        border-radius: 1rem !important;
        background: linear-gradient(145deg, var(--dobby-surface), rgba(30, 41, 59, 0.42)) !important;
        box-shadow: 0 16px 38px rgba(2, 6, 23, 0.22);
        backdrop-filter: blur(18px);
        -webkit-backdrop-filter: blur(18px);
        transition: transform 160ms ease, border-color 160ms ease, box-shadow 160ms ease;
      }

      .service-card:hover,
      .bookmark-card:hover {
        transform: translateY(-4px) scale(1.01);
        border-color: rgba(103, 232, 249, 0.45) !important;
        background: linear-gradient(145deg, var(--dobby-surface-hover), rgba(49, 46, 129, 0.42)) !important;
        box-shadow:
          0 22px 50px rgba(2, 6, 23, 0.36),
          0 0 24px rgba(34, 211, 238, 0.08);
      }

      li.service[id^="dobby-"] .service-card,
      li.service[id^="dobby-"] .service-card:hover {
        border-left-color: var(--host-dobby) !important;
        border-left-width: 4px !important;
      }

      li.service[id^="rowling-"] .service-card,
      li.service[id^="rowling-"] .service-card:hover {
        border-left-color: var(--host-rowling) !important;
        border-left-width: 4px !important;
      }

      li.service[id^="dobby-"] .service-description::before,
      li.service[id^="rowling-"] .service-description::before {
        display: inline-block;
        margin-right: 0.45rem;
        padding: 0.08rem 0.38rem;
        border: 1px solid currentColor;
        border-radius: 9999px;
        font-size: 0.55rem;
        font-weight: 800;
        line-height: 1.25;
        letter-spacing: 0.08em;
        vertical-align: 0.08rem;
      }

      li.service[id^="dobby-"] .service-description::before {
        content: "DOBBY";
        color: var(--host-dobby);
        background: var(--host-dobby-soft);
      }

      li.service[id^="rowling-"] .service-description::before {
        content: "ROWLING";
        color: var(--host-rowling);
        background: var(--host-rowling-soft);
      }

      .service-card img {
        filter: drop-shadow(0 8px 12px rgba(2, 6, 23, 0.42));
      }

      #information-widgets {
        margin-top: 0.75rem !important;
      }

      #widgets-wrap {
        display: grid !important;
        grid-template-columns: minmax(34rem, 0.95fr) minmax(42rem, 1.45fr);
        align-items: center;
        gap: 0.75rem !important;
        padding: 0.65rem 0.8rem;
        border: 1px solid var(--dobby-border);
        border-radius: 1rem;
        background: rgba(15, 23, 42, 0.62);
        box-shadow: 0 12px 32px rgba(2, 6, 23, 0.2);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
      }

      #information-widgets-right {
        display: grid !important;
        grid-template-columns: minmax(18rem, 1fr) auto auto;
        align-items: center;
        gap: 0 !important;
        min-width: 0;
      }

      #information-widgets .widget-container,
      #information-widgets .information-widget-form {
        min-height: 3.75rem;
        margin: 0 !important;
      }

      #information-widgets .information-widget-glances {
        min-width: 0;
        padding-right: 0.85rem;
      }

      #information-widgets .information-widget-search {
        min-width: 0;
        padding: 0 0.75rem;
        border-left: 1px solid var(--dobby-border);
        border-right: 1px solid var(--dobby-border);
      }

      #information-widgets .information-widget-openmeteo,
      #information-widgets .information-widget-error {
        min-width: 10rem;
        padding: 0 0.9rem;
      }

      #information-widgets .information-widget-datetime {
        min-width: 12rem;
        padding-left: 0.9rem;
        border-left: 1px solid var(--dobby-border);
      }

      #information-widgets .information-widget-search input {
        height: 2.5rem;
        border-radius: 0.7rem;
        background: rgba(255, 255, 255, 0.065);
      }

      @media (max-width: 1180px) {
        #widgets-wrap {
          grid-template-columns: 1fr;
        }

        #information-widgets .information-widget-glances {
          padding-right: 0;
          padding-bottom: 0.65rem;
          border-bottom: 1px solid var(--dobby-border);
        }
      }

      @media (max-width: 760px) {
        #information-widgets-right {
          grid-template-columns: 1fr 1fr;
        }

        #information-widgets .information-widget-search {
          grid-column: 1 / -1;
          padding: 0 0 0.65rem;
          border: 0;
          border-bottom: 1px solid var(--dobby-border);
        }

        #information-widgets .information-widget-openmeteo,
        #information-widgets .information-widget-error,
        #information-widgets .information-widget-datetime {
          min-width: 0;
          padding: 0.65rem 0.5rem 0;
          border-left: 0;
        }
      }

      h2 {
        letter-spacing: 0.055em;
        text-transform: uppercase;
      }

      ::selection {
        color: #ecfeff;
        background: rgba(8, 145, 178, 0.72);
      }

      @media (max-width: 768px) {
        #page_container {
          padding-top: 0.75rem;
        }

        .service-card:hover,
        .bookmark-card:hover {
          transform: translateY(-2px);
        }
      }

      @media (prefers-reduced-motion: reduce) {
        .service-card,
        .bookmark-card {
          transition: none;
        }
      }
    '';
  };
}
