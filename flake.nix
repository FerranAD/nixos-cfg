{
  description = "Ferran Aran's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    pyprland.url = "github:hyprland-community/pyprland";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.albus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ inputs.hyprpanel.overlay ];
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./hosts/albus/configuration.nix ];
      };

      nixosConfigurations.hedwig = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./hosts/hedwig/configuration.nix ];
      };
    };
}
