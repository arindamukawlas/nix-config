{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  #pkgs-stable,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    #overlays = [
    #(final: prev: {
    #  pkgs-stable = import pkgs-stable {
    #    system = "x86_64-linux";
    #    config.allowUnfree = true;
    #  };
    #})
    #];
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        substituters = [
          "https://cache.nixos.org"
          "https://cachix.cachix.org"
          "https://nvf.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
          "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = [
          "root"
          "arindamukawlas"
        ];

        # Enable flakes and new 'nix' command
        experimental-features = [
          "nix-command"
          "flakes"
          "no-url-literals"
          "pipe-operators"
        ];

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
    # Set hostname to default for device
    hostName = lib.mkDefault "";

    #Enable networkmanager
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
    nameservers = [
      "2a07:a8c0::ab:d144"
      "2a07:a8c1::ab:d144"
      "45.90.28.201"
      "45.90.30.201"
    ];
  };

  # Configure Console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "colemak/mod-dh-ansi-us";
  };

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    git = {
      config = {
        credential.helper = "cache";
      };
    };

    #Enable zsh integration into system
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
    # Enable virtualisation using qemu and virtmanager
    virt-manager = {
      enable = true;
    };
    #Enable hyprland
    hyprland = {
      enable = true;
      # Enable legacy support for x11 apps
      xwayland = {
        enable = true;
      };
      #Launch hyprland using systemd
      withUWSM = true;
    };
    dconf = {
      enable = true;
    };
    uwsm = {
      enable = true;
    };
    waybar = {
      enable = true;
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    #extraLocaleSettings = {
    # LC_ADDRESS = "en_IN";
    # LC_IDENTIFICATION = "en_IN";
    # LC_MEASUREMENT = "en_IN";
    # LC_MONETARY = "en_IN";
    # LC_NAME = "en_IN";
    # LC_NUMERIC = "en_IN";
    # LC_PAPER = "en_IN";
    # LC_TELEPHONE = "en_IN";
    # LC_TIME = "en_IN";
    #};
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    #pulseaudio = {
    #  enable = true;
    # configFile = pkgs.writeText "default.pa" ''
    #   load-module module-bluetooth-policy
    #   load-module module-bluetooth-discover
    #   load-module module-switch-on-connect
    #   ## module fails to load with
    #   ##   module-bluez5-device.c: Failed to get device path from module arguments
    #   ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    #   # load-module module-bluez5-device
    #   # load-module module-bluez5-discover
    # '';
    # package = pkgs.pulseaudioFull;
    #};
  };
  services = {
    blueman.enable = true;
    gvfs.enable = true;
    avahi.enable = false;
    journald.extraConfig = "SystemMaxUse=50M";
    # Enable CUPS to print documents
    printing = {
      enable = true;
      drivers = [
        pkgs.canon-capt
      ];
    };
    flatpak.enable = true;
    # Disable x11 but use it's setting for keyboard layout
    xserver = {
      enable = false;
      xkb = {
        variant = "colemak/mod-dh-ansi-us";
        layout = "us";
      };
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --remember --remember-session --time --time-format '%d %b %Y  -  %T  -  %A' --theme 'input=red' --window-padding 1 --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot'";
          user = "greeter";
        };
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
      #NextDNS Servers
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
      systemService = false;
      settings = {
        devices = {
          "hp" = {
            id = "T3XEOUW-4KWYVZ6-J7PF4F6-JMREGCI-ZQTIWTO-CNY33TR-UVESIJK-GRVLGQF";
          };
          "cmf" = {
            id = "VRUV5YO-VRLTQM3-LHR3XPZ-MM4VALU-2ANNP7G-EFTZXCN-PJW4FBX-5O6N7QQ";
          };
        };
        folders = {
          "Obsidian" = {
            path = "/home/arindamukawlas/Obsidian";
            devices = [
              "hp"
              "cmf"
            ];
          };
          "KeePassXC" = {
            path = "/home/arindamukawlas/KeePassXC";
            devices = [
              "hp"
              "cmf"
            ];
          };
        };
      };
    };
  };

  # Do not create default Syncthing folder
  systemd = {
    services = {
      syncthing = {
        environment.STNODEFAULTFOLDER = "true";
        wantedBy = lib.mkForce [ ];
      };
      syncthing-init.wantedBy = lib.mkForce [ ];
      NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
      NetworkManager.wantedBy = lib.mkForce [ ];
      NetworkManager-dispatcher.wantedBy = lib.mkForce [ ];
    };
  };
  # Allow users to use virtualisation
  users.groups.libvirtd.members = [
    "root"
    "arindamukawlas"
  ];

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  # Define user account
  users = {
    # Set user accounts based on config only
    mutableUsers = false;

    # Make Zsh default for all users
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
          "flatpak"
          "audio"
          "video"
          "input"
          "qemu-libvirtd"
        ];
        home = "/home/arindamukawlas";
        createHome = true;
        hashedPasswordFile = config.sops.secrets."unix/arindamukawlas".path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIMXgHrtVIXcr2z0qT+EkVxMzBlIwAA2++hTvdhPbWcr arindamukawlas@gmail.com"
        ];
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
    sharedModules = [
      {
        stylix.targets = {
          qt = {
            enable = false;
          };
          zellij = {
            enable = false;
          };
          neovim = {
            enable = false;
          };
          hyprlock = {
            enable = false;
          };
        };
      }
    ];
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      arindamukawlas = import ../users/arindamukawlas.nix;
    };
    backupFileExtension = "backup";
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    override = {
      base00 = "0a0e14";
    };
    image = pkgs.fetchurl {
      url = "https://i.imgur.com/GU1bLtO.jpeg";
      hash = "sha256-uNsVFj61snPTNB19QknbXuVFr3e+tq2mc1pf1KAeWds=";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
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
      extraRules = [
        {
          users = [ "greeter" ];
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl reboot";
              options = [
                "SETENV"
                "NOPASSWD"
              ];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl poweroff";
              options = [
                "SETENV"
                "NOPASSWD"
              ];
            }
          ];
        }
      ];
    };
    polkit = {
      enable = true;
    };
    rtkit = {
      enable = true;
    };
  };

  documentation = {
    #  nixos = {
    # includeAllModules = true;
    #};
    man = {
      generateCaches = true;
    };
    dev = {
      enable = true;
    };
  };

  fonts.packages =
    with pkgs;
    [
      nerd-fonts.jetbrains-mono
      lexend
      inter
    ]
    ++ [
      inputs.custom-fonts.packages.${pkgs.stdenv.hostPlatform.system}.san-francisco
    ];

  environment = {
    systemPackages =
      let
        zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
        # waybarOverride = (
        #   pkgs.waybar.overrideAttrs (oldAttrs: {
        #     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        #   })
        # );
      in
      lib.mkBefore (
        (with pkgs; [

          nerd-font-patcher

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

          python3Full

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
          ripgrep-all
          tokei
          zoxide
          tree
          fzf
          fd
          btop
          gh
          bat
          zellij
          ripunzip
          zip
          eza
          xh
          gitui
          dust
          dua
          hyperfine
          evil-helix
          bacon
          cargo-info
          fselect
          rusty-man
          #delta

          tldr
          sherlock
          treefmt
          ssh-to-age
          sops
          age
          jq
          stylua
          deno
          ghostty
          vscodium
          kitty
          foot

          chromium
          zen-browser
          gcc
          gnumake
          thunderbird
          syncthing
          keepassxc
          keepassxc-go
          git-credential-keepassxc
          qemu
          wev
          obsidian
          qt6ct
          wf-recorder

          # Display Manager
          greetd.greetd
          greetd.tuigreet

          # UWSM
          uwsm
          python313Packages.pyxdg
          python313Packages.dbus-python
          util-linux
          newt
          libnotify

          hyprland

          #Night Light for Hyprland
          hyprsunset

          # Lock screen for Hyprland
          hyprlock

          # Cursor theme for Hyprland
          nwg-look
          systemd
          # App Runner for Hyprland
          rofi-wayland
          killall
          bottles
          qbittorrent-enhanced
          wine
          onlyoffice-desktopeditors
          masterpdfeditor
          libreoffice-qt6-fresh
          hunspell
          zathura
          telegram-desktop
          udiskie
          pavucontrol
          nwg-bar
          hypridle
          papirus-icon-theme
          papirus-folders
          wl-clip-persist
          cliphist
          hyprls
          networkmanagerapplet

          inputs.pyprland.packages.${pkgs.stdenv.hostPlatform.system}.pyprland
          socat

          hyprland-qt-support
          qt6.qtwayland
          qt5.qtwayland
          libsForQt5.xwaylandvideobridge
          chromium
          hyprpolkitagent
          coreutils
          xdg-desktop-portal-gtk
          vesktop
          yazi

          # Wallpaper engine for Hyprland
          hyprpaper

          # Screenshot for Hyprland
          grimblast
          grim
          slurp
          hyprpicker
          wl-clipboard

          # Screen recording for Hyprland
          pipewire
          wireplumber
          xdg-desktop-portal-hyprland
          obs-studio
          obs-studio-plugins.wlrobs

          # Status bar for Hyprland
          waybar
          kdePackages.ark
          android-tools

          # Notifications for Hyprland
          swaynotificationcenter

          hyprland-qtutils
          chafa

          imagemagick
        ])
      );

    shells = [ pkgs.zsh ];

    enableAllTerminfo = true;

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      UWSM_SILENT_START = "1";
      XDG_CONFIG_HOME = "/home/arindamukawlas/.config";
      XDG_DATA_HOME = "/home/arindamukawlas/.local/share";
      XDG_CACHE_HOME = "/home/arindamukawlas/.cache";
      XDG_STATE_HOME = "/home/arindamukawlas/.local/state";
      XDG_PICTURES_DIR = "/home/arindamukawlas/Pictures";
      XDG_SCREENSHOTS_DIR = "/home/arindamukawlas/Pictures/Screenshots/";
    };

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    pathsToLink = [ "/share/zsh" ];

    shellAliases = {
      nix-lspkgs = "nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree";
      nix-wipehst = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
      nix-gc = "sudo nix-collect-garbage --delete-old; nix-collect-garbage --delete-old; sudo nix-collect-garbage -d";
      nix-clean = "nix-wipehst; sudo nix-collect-garbage --delete-old; nix-collect-garbage --delete-old; nix-store --optimise; sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration switch";
      get-age-key = "read -s SSH_TO_AGE_PASSPHRASE; export SSH_TO_AGE_PASSPHRASE; ssh-to-age -i ~/.ssh/id_ed25519 -private-key; unset SSH_TO_AGE_PASSPHRASE";
    };

    interactiveShellInit = '''';

    etc = {
      "greetd/config.toml" = {
        text = ''
          [terminal]
          vt = 1

          [default_session]
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --user-menu --remember --remember-session --remember-user-session --time --time-format '%d %b %Y  -  %T  -  %A' --theme 'input=red' --window-padding 1 --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot'"
          user = "greeter"
        '';
      };
      "security/faillock.conf" = {
        text = "deny = 0";
      };
    };
  };
}
