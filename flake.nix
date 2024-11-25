{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    #nixpkgs-stable = {
    #  url = "github:nixos/nixpkgs/nixos-24.05";
    #};

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      #nixpkgs-stable, 
      home-manager,
      disko,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in
    #overlay-stable = final: prev: {
    #  stable = import nixpkgs-stable {
    #    inherit system;
    #    config.allowUnfree = true;
    #  };
    #};
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      nixosConfigurations = {
        vbox = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            #(
            #  { config, pkgs, ... }:
            #  {
            #    nixpkgs.overlays = [ overlay-stable ];
            #  }
            #)
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  arindamukawlas = import ./home-manager/arindamukawlas.nix;
                  root = import ./home-manager/root.nix;
                };
              };
            }
          ];
        };
      };
    };
}
