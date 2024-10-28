{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../shared/configuration.nix
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };

    hostPlatform = "aarch64-linux";

    # You can add overlays here
    overlays = [
      outputs.nix-on-droid.overlays.default
    ];
  };

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  terminal = {
    font = "${pkgs.sfmonoNerdFontLig}/share/fonts/opentype/LigaSFMonoNerdFont-Regular.otf";
  };
}
