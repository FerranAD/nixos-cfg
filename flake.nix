{
  description = "Nixos config flake";

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
    {
      self,
      nixpkgs,
      ...
    } @ inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          inputs.hyprpanel.overlay
        ];
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.albus = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = {
          inherit system;
          inherit inputs;
        };
        modules = [
          ./hosts/albus/configuration.nix
        ];
      };
    };
}
