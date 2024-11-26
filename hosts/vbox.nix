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
    imports = [ ./base.nix ];

    boot = {
        initrd = {
            availableKernelModules = [
                "ata_piix"
                "ohci_pci"
                "ehci_pci"
                "ahci"
                "sd_mod"
                "sr_mod"
            ];
            kernelModules = [ ];
            checkJournalingFS = false;
        };
        kernelModules = [ ];
        extraModulePackages = [ ];
    };

    # Set time zone.
    time.timeZone = "Asia/Kolkata";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Do Not Change!!
    system = {
        stateVersion = "24.05";
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/db445b13-ce54-48fa-ab06-d64b3935726c";
            fsType = "ext4";
        };

        "/boot" = {
            device = "/dev/disk/by-uuid/C967-8C22";
            fsType = "vfat";
            options = [
                "fmask=0077"
                "dmask=0077"
            ];
        };
    };

    swapDevices = [
        {
            device = "/dev/disk/by-uuid/97aff63e-fa1c-4c81-b020-514b069503b9";
        }
    ];

    networking = {
        useDHCP = lib.mkDefault true;
    };

    nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";
    };
    
    virtualisation.virtualbox.guest.enable = true;
}