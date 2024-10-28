{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };

    # You can add overlays here
    overlays = [
      outputs.nix-on-droid.overlays.default
    ];
  };

  home-manager.config = {pkgs, ...}: {
    system.os = "nix-on-droid";
    home.stateVersion = "24.05";
    nixpkgs.overlays = config.nixpkgs.overlays;
    imports = [
      (import ../shared/programs/bat {})
      (import ../shared/programs/direnv {inherit config;})
      (import ../shared/programs/eza {})
      (import ../shared/programs/fzf {})
      (import ../shared/programs/git {inherit lib pkgs;})
      (import ../shared/programs/htop {inherit config;})
      (import ../shared/programs/starship {})
      (import ../shared/programs/zsh {
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

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  terminal = {
    font = "${pkgs.sfmonoNerdFontLig}/share/fonts/opentype/LigaSFMonoNerdFont-Regular.otf";
  };
}
