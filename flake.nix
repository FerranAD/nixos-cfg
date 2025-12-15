{
  description = "Ferran Aran's NixOS configuration";

  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager-stable.url = "github:nix-community/home-manager/release-25.05";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    # Secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      type = "git";
      # url = "ssh://git@github.com/ferranad/nixos-secrets.git?dir=secrets";
      url = "ssh://git@github.com/ferranad/nixos-secrets.git";
      submodules = true;
      flake = false;
      allRefs = true;
    };

    # Desktop
    hyprland.url = "github:hyprwm/hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix = {
      url = "github:nix-community/autofirma-nix"; # If you're tracking NixOS unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      agenix-rekey,
      agenix,
      disko,
      nixos-generators,
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
                config.allowUnfree = true;
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

      packages.aarch64-linux = {
        hedwig-iso = nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          modules = [
            ./minimal-cfg.nix
          ];
          specialArgs = {
            hostname = "hedwig";
          };
          format = "sd-aarch64-installer";
        };
      };

      nixosConfigurations.hedwig-install = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-stable {
          system = "aarch64-linux";
          overlays = [
            agenix-rekey.overlays.default
          ];
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/hedwig/configuration.nix
          {
            age.identityPaths = nixpkgs.lib.mkForce [
              "${/home/ferran/.ssh/agenix-hedwig}"
            ];
          }
        ];
      };

      nixosConfigurations.hedwig = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-stable {
          system = "aarch64-linux";
          overlays = [
            agenix-rekey.overlays.default
          ];
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/hedwig/configuration.nix
        ];
      };

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };
    };
}
