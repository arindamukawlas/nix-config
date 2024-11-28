{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ../base.nix
    ../../modules/vscode-server.nix
  ];

  boot = {
    initrd = {
      checkJournalingFS = false;
    };
  };

  # Set time zone.
  time.timeZone = "Asia/Kolkata";

  # Do Not Change!!
  system = {
    stateVersion = "24.05";
  };

  networking = {
    hostname = "wsl";
  };

  wsl = {
    enable = true;
    defaultUser = "arindamukawlas";
    startMenuLaunchers = true;
    wslConf = {
      user.default = "arindamukawlas";
    };
  };

  vscode-remote-workaround.enable = true;

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };
}
