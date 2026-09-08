{
  description = "yenterick's multi-device NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    infinite-desktop.url = "github:imashk14/hyprland-infinite-desktop";

    hyprmod = {
      url = "github:BlueManCZ/hyprmod";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      home-manager-modules = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.yenterick = {
          imports = [ ./home/home.nix ];
          home.stateVersion = "26.05";
        };
      };
    in
    {
      nixosConfigurations = {
        arsene = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/arsene.nix
            home-manager.nixosModules.home-manager
            home-manager-modules
            ({ pkgs, ... }: {
              environment.systemPackages = [ inputs.infinite-desktop.packages.${system}.default ];
            })
          ];
        };

        satanael = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/satanael.nix
            home-manager.nixosModules.home-manager
            home-manager-modules
            ({ pkgs, ... }: {
              environment.systemPackages = [ inputs.infinite-desktop.packages.${system}.default ];
            })
          ];
        };
      };
    };
}