# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
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
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default

    # You can also split up your configuration and import pieces of it here:
    ../shared/configuration.nix

    # Import your generated (nixos-generate-config) hardware configuration
    # ./hardware-configuration.nix
  ];

  console.keyMap = "us";

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

  networking.hostName = "nixos-wsl";
  programs.dconf.enable = true;

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    vscode-server.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  time.hardwareClockInLocalTime = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  wsl = {
    enable = true;

    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = false;
      network.generateHosts = false;
    };

    defaultUser = "javacafe";
    startMenuLaunchers = true;
    docker-desktop.enable = false;
  };
}
