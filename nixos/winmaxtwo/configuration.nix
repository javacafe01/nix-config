# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.gpd-win-max-2-2023

    # You can also split up your configuration and import pieces of it here:
    ../shared/configuration.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };

    hostPlatform = "x86_64-linux";

    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
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
    loader.systemd-boot.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
  };

  networking = {
    hostName = "winmaxtwo";
    networkmanager.enable = true;
  };

  programs = {
    dconf.enable = true;

    thunar = {
      enable = true;

      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };

  services = {
    acpid.enable = true;

    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    hardware.bolt.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;

      displayManager = {
        autoLogin = {
          enable = false;
          user = "javacafe";
        };

        defaultSession = "none+awesome";

        lightdm = {
          enable = true;
          greeters.mini.enable = true;
        };
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  time.hardwareClockInLocalTime = true;
}
