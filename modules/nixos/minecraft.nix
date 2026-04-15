{
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall.allowedTCPPorts = [
    5501
    5502
    5602
    5601
    8123
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/data/minecraft";

    servers = {
      xikibby-server = {
        enable = true;
        package = pkgs.papermcServers.papermc-1_21_10;
        serverProperties = {
          server-port = 5501;
          gamemode = "peaceful";
          motd = "Xikibby server";
          max-players = 2;
          view-distance = 20;
          white-list = false;
          online-mode = false;
          pause-when-empty-seconds = 15; # This has to be set to -1 for plugins to work
          enable-rcon = true;
          "rcon.port" = 5601;
          "rcon.password" = "xikibby";
        };
        # whitelist = {
        #   ferranklk = "851972dc-5e1f-4a2b-936c-cdc396ad1377";
        # };

        symlinks = {
          "plugins/SimpleGraves.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/cymUGBSV/versions/O8cb9b9l/SimpleGraves-1.4.0.jar";
            sha256 = "1q385yr0scfca0sbxxl9jrv96iyyw8p1qikzp52vk65fy9qf17af";
            name = "SimpleGraves.jar";
          };
          "plugins/EssentialsX.jar" = builtins.fetchurl {
            url = "https://github.com/EssentialsX/Essentials/releases/download/2.21.2/EssentialsX-2.21.2.jar";
            sha256 = "1inz1c6zs4w3ckjil51yyz7r87rwvdk3cvw869y58g1gy0k90x8b";
            name = "EssentialsX.jar";
          };
          "plugins/AuthMeReloaded.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/3IEZ9vol/versions/oezVemzR/AuthMe-5.7.0-FORK-Universal.jar";
            sha256 = "0bhjsq2ad5xwy7q8f5r1mg0nsbfwjn5vkwjdvy8rfr8b7zcrdyqb";
            name = "AuthMeReloaded.jar";
          };
          "plugins/LuckPerms.jar" = builtins.fetchurl {
            url = "https://download.luckperms.net/1631/bukkit/loader/LuckPerms-Bukkit-5.5.42.jar";
            sha256 = "0d7rmgmb1crwbrizn0p7gdbf6x420mdx00g6k6sf6qs6a60h7bnx";
            name = "LuckPerms.jar";
          };
          "plugins/SimpleWhitelist.jar" = builtins.fetchurl {
            url = "https://hangarcdn.papermc.io/plugins/An1by/SimpleWhitelist/versions/paper-2.0.0/PAPER/simplewhitelist-paper-2.0.0.jar";
            sha256 = "1r4n0w1mw0ncgf96j39ch4wbsqjlp6b15bjm48gkfbj60n2pbcz8";
            name = "SimpleWhitelist.jar";
          };
          "plugins/Dynmap.jar" = builtins.fetchurl {
            url = "https://mediafilez.forgecdn.net/files/7460/127/Dynmap-3.8-spigot.jar";
            sha256 = "1mvd79133q2xkryasnmmann2x0kdvrhi6540w0z6mv5krgldnwa7";
            name = "Dynmap.jar";
          };
        };
      };
      pofnet-server = {
        enable = true;
        package = pkgs.papermcServers.papermc-1_21_10;
        jvmOpts = "-Xms8G -Xmx12G";
        serverProperties = {
          server-port = 5502;
          gamemode = "peaceful";
          motd = "Pofnet server";
          max-players = 5;
          view-distance = 20;
          pause-when-empty-seconds = 15; # This has to be set to -1 for plugins to work
          enable-rcon = true;
          "rcon.port" = 5602;
          "rcon.password" = "pofnet";
        };
        whitelist = {
          ferranklk = "851972dc-5e1f-4a2b-936c-cdc396ad1377";
          oriolagobat2 = "669b5178-be69-4ffa-a05c-4f7a772865ea";
        };

        symlinks = {
          "plugins/SimpleGraves.jar" = builtins.fetchurl {
            url = "https://cdn.modrinth.com/data/cymUGBSV/versions/O8cb9b9l/SimpleGraves-1.4.0.jar";
            sha256 = "1q385yr0scfca0sbxxl9jrv96iyyw8p1qikzp52vk65fy9qf17af";
            name = "SimpleGraves.jar";
          };
          "plugins/Dynmap.jar" = builtins.fetchurl {
            url = "https://mediafilez.forgecdn.net/files/7460/127/Dynmap-3.8-spigot.jar";
            sha256 = "1mvd79133q2xkryasnmmann2x0kdvrhi6540w0z6mv5krgldnwa7";
            name = "Dynmap.jar";
          };
        };
        # files = {
        #   "config/paper-global.yml".value = {
        #     _version = 28;
        #     proxies = {
        #       proxy-protocol = false;
        #       velocity = {
        #         enabled = true;
        #         online-mode = false;
        #         secret = "secret";
        #       };
        #     };
        #   };
        # };
      };
    };
  };
}
