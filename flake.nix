{
  description = "Ferran Aran's NixOS configuration";

  inputs = {
    systems.url = "github:nix-systems/default-linux";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?rev=0726a0ecb6d4e08f6adced58726b95db924cef57";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager-stable.url = "github:nix-community/home-manager/release-25.11";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence.url = "github:nix-community/impermanence?rev=4a07d84eaaac3d8cfd26a5f7a3da8161df0e75cd";
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
    pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix = {
      url = "github:nix-community/autofirma-nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Server
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Misc
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
      nixpkgs-unstable,
      agenix-rekey,
      nixarr,
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

      nixosConfigurations.albus-install =
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
            {
              age.identityPaths = nixpkgs.lib.mkForce [
                "${/etc/nixos/agenix-albus}"
              ];

              # Create the /persist/home folder if it is not created, make the folder rwx by everyone, since we can't chown with
              # the real ${user}, yet...
              system.activationScripts.addHomeImpermanenceFolder.text = ''
                echo "Adding your /persist/home folder..."
                mkdir -p /persist/home
                # I know, this is a mess and it is temporal!
                chmod -R 777 /persist/home
              '';
            }
          ];
        };

      nixosConfigurations.rowling =
        let
          system = "aarch64-linux";
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
          };
          modules = [
            ./hosts/rowling/configuration.nix
          ];
        };

      nixosConfigurations.dobby-install =
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
          };
          modules = [
            ./hosts/dobby/configuration.nix
            {
              age.identityPaths = nixpkgs.lib.mkForce [
                "${/etc/nixos/agenix-dobby}"
              ];
            }
          ];
        };

      nixosConfigurations.dobby =
        let
          system = "x86_64-linux";
        in
        nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs-unstable {
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
            ./hosts/dobby/configuration.nix
          ];
        };

      nixosConfigurations.rubeus-install =
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
          };
          modules = [
            ./hosts/rubeus/configuration.nix
            {
              age.identityPaths = nixpkgs.lib.mkForce [
                "${/etc/nixos/agenix-rubeus}"
              ];
            }
          ];
        };

      nixosConfigurations.rubeus =
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
          };
          modules = [
            ./hosts/rubeus/configuration.nix
          ];
        };

      nixosConfigurations.oci-base = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/oci-image.nix"
          ./hosts/minimal-cfg.nix
        ];
        specialArgs = {
          hostname = "rowling";
        };
      };

      packages.aarch64-linux = {
        hedwig-iso = nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          modules = [
            ./hosts/minimal-cfg.nix
          ];
          specialArgs = {
            hostname = "hedwig";
          };
          format = "sd-aarch64-installer";
        };
        oracle-iso = self.nixosConfigurations.oci-base.config.system.build.OCIImage;
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

      nixosConfigurations.minimal-x86 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (
            { ... }:
            {
              users.users.root = {
                openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDO11F5Mw0JYYi/IgmgfV7bRZS7yDi5y/FSDpM3Ep6Qt openpgp:0xBC69F42C"
                ];
              };
              services.openssh = {
                enable = true;
                settings.PermitRootLogin = "yes";
              };
            }
          )
        ];
      };

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;

        # Skip hosts that either don't use agenix or are intentionally minimal/test builds.
        nixosConfigurations = nixpkgs.lib.filterAttrs (
          name: _:
          !(builtins.elem name [
            "minimal-x86"
            "oci-base"
          ])
        ) self.nixosConfigurations;
      };
    };
}
