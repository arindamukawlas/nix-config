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
    ../cachix.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
    inputs.sops-nix.nixosModules.sops
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

  programs = {
    git = {
      config = {
        credential.helper = "cache";
      };
    };
    zsh = {
      enable = true;
    };
    nix-index = {
      enable = true;
    };
    nix-index-database = {
      comma.enable = true;
    };
    nix-ld = {
      enable = true;
    };
    ssh = {
      startAgent = true;
    };
    virt-manager = {
      enable = true;
    };
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      withUWSM = true;
    };
    dconf = {
      enable = true;
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    #extraLocaleSettings = {
    # LC_ADDRESS = "en_IN";
    # LC_IDENTIFICATION = "en_IN";
    #  LC_MEASUREMENT = "en_IN";
    #  LC_MONETARY = "en_IN";
    #  LC_NAME = "en_IN";
    #   LC_NUMERIC = "en_IN";
    # LC_PAPER = "en_IN";
    #  LC_TELEPHONE = "en_IN";
    #   LC_TIME = "en_IN";
    #};
  };

  hardware = {
    bluetooth.enable = true;
  };
  services = {
    # Enable CUPS to print documents
    printing.enable = true;

    xserver = {
      enable = false;
      xkb = {
        variant = "colemak/mod-dh-ansi-us";
        layout = "us";
      };
    };
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    # Enable sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable ssh
    openssh = {
      enable = true;
    };

    resolved = {
      enable = true;
      dnssec = "true";
      dnsovertls = "true";
      extraConfig = ''
        [Resolve]
        DNS=45.90.28.0#abd144.dns.nextdns.io
        DNS=2a07:a8c0::#abd144.dns.nextdns.io
        DNS=45.90.30.0#abd144.dns.nextdns.io
        DNS=2a07:a8c1::#abd144.dns.nextdns.io
      '';
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      settings = {
        devices = {
          "hp" = {
            id = "T3XEOUW-4KWYVZ6-J7PF4F6-JMREGCI-ZQTIWTO-CNY33TR-UVESIJK-GRVLGQF";
          };
        };
        folders = {
          "KeePassXC" = {
            path = "/var/lib/syncthing/keepassxc";
            devices = [ "hp" ];
          };
        };
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  users.groups.libvirtd.members = [ "arindamukawlas" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # Define user account
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        isSystemUser = true;
        uid = 0;
        home = "/root";
      };
      arindamukawlas = {
        uid = 1000;
        description = "Arindam Kawlas";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "libvirtd"
          "input"
          "networkmanager"
        ];
        home = "/home/arindamukawlas";
        createHome = true;
        hashedPasswordFile = config.sops.secrets."unix/arindamukawlas".path;
      };
    };
  };
  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      arindamukawlas = import ../users/arindamukawlas.nix;
      root = import ../users/root.nix;
    };
    backupFileExtension = "backup";
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/arindamukawlas/.config/sops/age/keys.txt";
    };
    secrets = {
      "unix/arindamukawlas" = {
        neededForUsers = true;
      };
    };
  };

  security = {
    sudo = {
      execWheelOnly = true;
    };
    polkit = {
      enable = true;
    };
    rtkit = {
      enable = true;
    };
  };

  documentation = {
    nixos = {
      includeAllModules = true;
    };
    man = {
      generateCaches = true;
    };
    dev = {
      enable = true;
    };
  };

  environment = {
    systemPackages =
      let
        zen-browser = inputs.zen-browser.packages.x86_64-linux.default;
        waybarOverride = (
          pkgs.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          })
        );
      in
      lib.mkBefore (
        with pkgs;
        [
          # Nix
          nixfmt-rfc-style
          nix-tree
          manix

          # Rust
          cargo
          rustc
          rustfmt
          rustlings
          clippy

          # Zig
          zig

          # LSPs
          zls
          rust-analyzer
          lua-language-server

          zsh
          git
          lazygit
          tree-sitter
          vim
          wget
          wget2
          curl
          neofetch
          neovim
          ripgrep
          zoxide
          tree
          fzf
          gh
          bat
          zellij
          ripunzip
          sherlock
          treefmt
          ssh-to-age
          sops
          age
          stylua
          deno
          ghostty
          vscodium
          chromium
          cachix
          zen-browser
          nerd-fonts.jetbrains-mono
          gcc
          gnumake
          thunderbird
          syncthing
          keepassxc
          git-credential-keepassxc
          qemu

          #Hyprland
          python313Packages.pyxdg
          python313Packages.dbus-python
          util-linux
          newt
          rofi-wayland
          libnotify
          pipewire
          wireplumber
          qt6.qtwayland
          qt5.qtwayland
          hyprpolkitagent

          waybarOverride
          dunst
          swww
          kitty
        ]
      );

    shells = [ pkgs.zsh ];

    enableAllTerminfo = true;

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CONFIG_HOME = "/home/arindamukawlas/.config";
      XDG_DATA_HOME = "/home/arindamukawlas/.local/share";
      XDG_CACHE_HOME = "/home/arindamukawlas/.cache";
      XDG_STATE_HOME = "/home/arindamukawlas/.local/state";
    };

    pathsToLink = [ "/share/zsh" ];

    shellAliases = {
      nix-lspkgs = "nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree";
      nix-wipehst = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
      nix-gc = "sudo nix-collect-garbage --delete-old; nix-collect-garbage --delete-old; sudo nix-collect-garbage -d";
      nix-clean = "nix-wipehst; sudo nix-collect-garbage --delete-old; nix-collect-garbage --delete-old; nix-store --optimise; sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration switch";
      get-age-key = "(read -r -s SSH_TO_AGE_PASSPHRASE\? -p 'Enter passphrase: '; export SSH_TO_AGE_PASSPHRASE; ssh-to-age -i ~/.ssh/id_ed25519 -private-key)";
    };

    interactiveShellInit = '''';
  };
}
