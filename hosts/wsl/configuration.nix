{
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ../base.nix
    inputs.nixos-wsl.nixosModules.wsl
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
    hostName = "wsl";
  };

  wsl = {
    enable = true;
    defaultUser = "arindamukawlas";
    startMenuLaunchers = true;
    wslConf = {
      user.default = "arindamukawlas";
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };
}
