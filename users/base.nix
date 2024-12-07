{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  xdg = {
    enable = true;
    configFile = {
      "zsh" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/programs/zsh";
      };
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/programs/nvim";
      };
    };
  };

  programs = {
    zsh = {
#      enable = true;
#      dotDir = ".config/zsh";
    };
    git = {
      enable = true;
      userName = "Arindam Kawlas";
      userEmail = "arindamukawlas@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
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
        telescope-fzf-native-nvim
        nvim-treesitter.withAllGrammars
      ];
    };
    nix-index = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
  };

  home = {
    stateVersion = "24.05";
    preferXdgDirectories = true;
    packages = with pkgs; [ ];
  };
}
