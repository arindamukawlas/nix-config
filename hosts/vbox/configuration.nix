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
    ./hardware-configuration.nix
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
}
