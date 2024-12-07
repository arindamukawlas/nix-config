{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      #(final: prev: {
      #  pkgs-stable = import nixpkgs-stable {
      #    inherit system;
      #    config.allowUnfree = true;
      #  };
      #};)
    ];
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes no-url-literals pipe-operators";

        # Use XDG spec for old commands
        use-xdg-base-directories = true;

        # Disable warning when current config has not been committed
        warn-dirty = false;

        # Deduplicate and optimise nix store
        auto-optimise-store = true;

        # Disable global flake registry
        flake-registry = "";

        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;

        substituters = lib.mkBefore [
          "https://nix-community.cachix.org?priority=1"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      # Make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      # Disable channels
      channel.enable = false;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
    };

  networking = {
    hostName = lib.mkDefault "";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  # Configure Console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "colemak/mod-dh-ansi-us";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    zsh = {
      enable = true;
    };
    nix-index = {
      enable = true;
    };
    nix-index-database = {
      comma.enable = true;
    };
  };

  services = {
    # Enable CUPS to print documents
    printing.enable = true;

    # Enable sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # Define user account
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      arindamukawlas = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "input"
          "networkmanager"
        ];
      };
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      arindamukawlas = import ../users/arindamukawlas.nix;
      root = import ../users/root.nix;
    };
  };

  environment = {
    systemPackages = lib.mkBefore (
      with pkgs;
      [
        # Nix
        nixfmt-rfc-style
        nix-tree
        manix

        zsh
        git
        vim
        wget
        curl
        neofetch
        neovim
        ripgrep
        zoxide
        fzf
      ]
    );

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CONFIG_HOME = "/home/arindamukawlas/.config";
      XDG_DATA_HOME = "/home/arindamukawlas/.local/share";
      XDG_CACHE_HOME = "/home/arindamukawlas/.cache";
      XDG_STATE_HOME = "/home/arindamukawlas/.local/state";
    };

    pathsToLink = [ "/share/zsh" ];

    interactiveShellInit = ''
      alias nix-lspkgs="nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree"
      alias nix-wipehst="sudo nix profile wipe-history --profile /nix/var/nix/profiles/system"
      alias nix-gc="sudo nix-collect-garbage --delete-old; nix-collect-garbage --delete-old; sudo nix-collect-garbage -d"
      alias nix-clean="nix-wipehst; sudo nix-collect-garbage --delete-old; nix-collect-garbage --delete-old; nix-store --optimise; sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration switch"
    '';
  };
}
