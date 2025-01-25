{
  lib,
  config,
  pkgs,
  ...
}:
{
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "24.05";
    preferXdgDirectories = true;
    packages = with pkgs; [ ];
    file = {
      ".zshenv" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/.zshenv";
      };
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
      "gh" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/gh";
        recursive = true;
      };
      "zellij" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/arindamukawlas/nix-config/dotfiles/zellij";
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
  };

  services = {
    ssh-agent = {
      enable = true;
    };
  };

}
