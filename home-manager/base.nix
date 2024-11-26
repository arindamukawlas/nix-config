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

  programs = {
    git = {
      enable = true;
      userName = "Arindam Kawlas";
      userEmail = "arindamukawlas@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    home-manager = {
      enable = true;
    };
  };

  home = {
    stateVersion = "24.05";
    packages = with pkgs; [ ];
  };
}
