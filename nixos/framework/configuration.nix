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
    inputs.niri-flake.nixosModules.niri
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

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
      inputs.niri-flake.overlays.niri
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

    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = with pkgs; [nixos-bgrt-plymouth];
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

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  environment = {
    variables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; [
      adwaita-icon-theme
      foot
      nautilus
      wl-clipboard
      wayland-utils
      libsecret
      xwayland-satellite-unstable
      swaybg
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
  };

  networking = {
    hostName = "framework";
    networkmanager.enable = true;
  };

  programs = {
    dconf.enable = true;

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    seahorse.enable = true;
  };

  services = {
    xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    gnome.sushi.enable = true;
    gvfs.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  time.hardwareClockInLocalTime = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];

    config.common.default = "*";
  };
}
