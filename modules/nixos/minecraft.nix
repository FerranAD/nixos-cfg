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
          white-list = true;
          pause-when-empty-seconds = 15; # This has to be set to -1 for plugins to work
        };
        whitelist = {
          ferranklk = "851972dc-5e1f-4a2b-936c-cdc396ad1377";
        };

      };
      pofnet-server = {
        enable = true;
        package = pkgs.papermcServers.papermc-1_21_10;
        serverProperties = {
          server-port = 5502;
          gamemode = "peaceful";
          motd = "Pofnet server";
          max-players = 5;
          white-list = true;
          pause-when-empty-seconds = 15; # This has to be set to -1 for plugins to work
        };
        whitelist = {
          ferranklk = "851972dc-5e1f-4a2b-936c-cdc396ad1377";
        };
      };
    };
  };
}
