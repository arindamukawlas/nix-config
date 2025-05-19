{
  description = "NixOS configuration";

  inputs = {

    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    # nixos-wsl = {
    #  url = "github:nix-community/NixOS-WSL/main";
    # };

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      #nixpkgs-stable,
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];
      systems = [ "x86_64-linux" ];
      perSystem =
        { ... }:
        {
          treefmt = {
            programs = {
              nixfmt = {
                enable = true;
              };
              deadnix = {
                enable = true;
              };
            };
          };
        };
      flake =
        let
          inherit (self) outputs;
          #pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
        in
        {
          nixosConfigurations = {
            vbox = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs outputs; };
              modules = [ ./hosts/vbox/configuration.nix ];
            };
            wsl = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs outputs; };
              modules = [ ./hosts/wsl/configuration.nix ];
            };
            hp = nixpkgs.lib.nixosSystem {
              #specialArgs = { inherit inputs outputs pkgs-stable; };
              specialArgs = { inherit inputs outputs; };
              modules = [ ./hosts/hp/configuration.nix ];
            };
          };
        };
    };
}
