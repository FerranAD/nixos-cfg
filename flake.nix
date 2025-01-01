{
  description = "Ferran Aran's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";

    pyprland.url = "github:hyprland-community/pyprland";

    catppuccin.url = "github:catppuccin/nix";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      type = "git";
      url = "ssh://git@github.com/ferranad/nixos-secrets.git?dir=secrets";
      submodules = true;
      flake = false;
      allRefs = true;
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      agenix-rekey,
      ...
    }@inputs:
    {
      nixosConfigurations.albus =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.hyprpanel.overlay
              agenix-rekey.overlays.default
            ];
            config.allowUnfree = true;
          };
          specialArgs = {
            inherit inputs;
            nurPkgs = (import inputs.nur) {
              nurpkgs = import inputs.nixpkgs {
                inherit system;
              };
              pkgs = import inputs.nixpkgs {
                inherit system;
              };
            };
          };
          modules = [
            ./hosts/albus/configuration.nix
          ];
        };

      nixosConfigurations.draco =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs-stable {
            inherit system;
            overlays = [
              agenix-rekey.overlays.default
            ];
            config.allowUnfree = true;
          };
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/draco/configuration.nix
            nixos-hardware.nixosModules.apple-t2
          ];
        };

      # nixosConfigurations.hedwig = nixpkgs.lib.nixosSystem {
      #   system = "aarch64-linux";
      #   specialArgs = {
      #     inherit inputs;
      #   };
      #   modules = [ 
      #     ./hosts/hedwig/configuration.nix 
      #     agenix.nixosModules.default
      #     agenix-rekey.nixosModules.default
      #   ];
      # };

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nodes = self.nixosConfigurations;
      };
    };
}
