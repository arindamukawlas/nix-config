{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "24.05";
    preferXdgDirectories = true;
    pointerCursor = lib.mkForce {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
      x11.enable = true;
    };
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
      lexend
    ];
    file = {
      ".zshenv" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/.zshenv";
      };
    };
  };
  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
  xdg = {
    enable = true;
    configFile = {
      "zsh" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/zsh";
        recursive = true;
      };
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/nvim";
        recursive = true;
      };
      "tmux" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/tmux";
        recursive = true;
      };
      "kitty" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/kitty";
        recursive = true;
      };
      "ghostty" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/ghostty";
        recursive = true;
      };
      "gh" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/gh";
        recursive = true;
      };
      "zellij" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/zellij";
        recursive = true;
      };
      "hypr" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/hypr";
        recursive = true;
      };
      "rofi" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/rofi";
        recursive = true;
      };
      "xdg-desktop-portal" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/xdg-desktop-portal";
        recursive = true;
      };
      "waybar" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/waybar";
        recursive = true;
      };
      "dunst" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/dunst";
        recursive = true;
      };
      "electron-flags.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/electron-flags.conf";
      };
      "chromium-flags.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/chromium-flags.conf";
      };
      "wlrobs" = {
        source = "${pkgs.obs-studio-plugins.wlrobs}/lib/obs-plugins/libwlrobs.so";
        target = "obs-studio/plugins/wlrobs/bin/64bit/libwlrobs.so";
      };
      "uwsm" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/uwsm";
        recursive = true;
      };
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Arindam Kawlas";
      userEmail = "arindamukawlas@gmail.com";
      maintenance = {
        enable = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        credential = {
          "https://github.com".helper = "!/run/current-system/sw/bin/gh auth git-credential";
          "https://gist.github.com".helper = "!/run/current-system/sw/bin/gh auth git-credential";
        };
      };
    };
    zellij = {
      enable = true;
      enableZshIntegration = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
      withPython3 = true;
      withRuby = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        nvim-treesitter-parsers.regex
        nvim-treesitter-parsers.bash
      ];
    };
    ssh = {
      enable = true;

    };
    nix-index = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };

    hyprcursor-phinger.enable = true;
  };

  services = {
    ssh-agent = {
      enable = true;
    };
  };
  wayland.windowManager.hyprland = {
    systemd.enable = false;
    plugins = [
    ];
  };
}
