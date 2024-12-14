{
  description = "NixOS configuration";

  inputs = {

    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # nixpkgs-stable = {
    #     url = "github:nixos/nixpkgs/nixos-24.05";
    # };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    # Nix Index
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      #nixpkgs-stable,
      nixos-wsl,
      nix-index-database,
      home-manager,
      disko,
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" ];
      #          formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      #         formatter = eachSystem (pkgs: treefmtEval.config.build.wrapper);
      #        checks = eachSystem (pkgs: {
      #         formatting = treefmtEval.config.build.check self;
      #      });

      flake =
        let
          inherit (self) outputs;
          system = "x86_64-linux";
        in
        {
          nixosConfigurations = {
            vbox = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit inputs outputs; };
              modules = [ ./hosts/vbox/configuration.nix ];
            };
            wsl = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit inputs outputs; };
              modules = [ ./hosts/wsl/configuration.nix ];
            };
          };
        };
    };
}
