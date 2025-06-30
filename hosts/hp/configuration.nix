{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../base.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "udev.log_priority=3"
      "init_on_alloc=0"
      "init_on_free=0"
      "i918.fastboot=1"
    ];
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
        netbootxyz.enable = true;
        edk2-uefi-shell.enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      checkJournalingFS = false;
    };
  };
  fileSystems."/".options = lib.mkAfter [
    "noatime"
    "nodiratime"
  ];

  networking = {
    hostName = "hp";
    interfaces.enp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.0.2";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.0.1";
      interface = "enp1s0";
    };
  };

  # Set time zone.
  time.timeZone = "Asia/Kolkata";

  # Do Not Change!!
  system = {
    stateVersion = "24.11";
  };
}
