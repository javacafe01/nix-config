{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  home-manager.config = {pkgs, ...}: {
    # system.os = "nix-on-droid";
    home.stateVersion = "24.05";
    nixpkgs.overlays = config.nixpkgs.overlays;
    imports = [
      (import ./../../home-manager/shared/programs/bat {})
      (import ./../../home-manager/shared/programs/direnv {inherit config;})
      (import ./../../home-manager/shared/programs/eza {})
      (import ./../../home-manager/shared/programs/fzf {})
      (import ./../../home-manager/shared/programs/git {inherit lib pkgs;})
      (import ./../../home-manager/shared/programs/starship {})
      (import ./../../home-manager/shared/programs/zsh {
        inherit config pkgs;
      })
    ];

    home.packages = lib.attrValues {
      inherit
        (pkgs)
        gh
        git
        neovim
        ;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://cache.ngi0.nixos.org/"
        "https://nix-community.cachix.org"
        "https://fortuneteller2k.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
      ];
    };
  };

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  terminal.font = "${pkgs.terminus-nerdfont}/share/fonts/truetype/NerdFonts/TerminessNerdFontMono-Regular.ttf";
  user.shell = "${pkgs.zsh}/bin/zsh";
}
