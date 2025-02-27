{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.lix-module.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    ../shared/configuration.nix
    ../shared/desktops/gnome.nix
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";

    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

      inputs.nixpkgs-f2k.overlays.stdenvs

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };

    plymouth = {
      enable = true;
      # theme = "nixos-bgrt";
      # themePackages = with pkgs; [nixos-bgrt-plymouth];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    loader.timeout = 5;
  };

  networking = {
    hostName = "framework";
    networkmanager.enable = true;

    wireless = {
      networks.eduroam = {
        auth = ''
          key_mgmt=WPA-EAP
          eap=PWD
          identity="ext:identity_edu"
          password="ext:pass_edu"
        '';
      };

      secretsFile = "/run/secrets/wireless.conf";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  time.hardwareClockInLocalTime = true;
  users.groups.libvirtd.members = ["gokulswam"];

  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };

        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };
}
