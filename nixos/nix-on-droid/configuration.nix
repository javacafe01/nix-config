{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  nix = {
    package = pkgs.lix;

    settings = {
      experimental-features = "nix-command flakes";

      substituters = [
        "https://cache.nixos.org"
        "https://cache.ngi0.nixos.org"
        "https://nix-community.cachix.org"
        "https://nix-on-droid.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.nix-on-droid.overlays.default
    ];
  };

  environment.etcBackupExtension = ".bak";

  programs = {
    bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    ssh.startAgent = true;
  };

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  terminal.font = "${pkgs.terminus-nerdfont}/share/fonts/truetype/NerdFonts/TerminessNerdFontMono-Regular.ttf";
  user.shell = "${pkgs.zsh}/bin/zsh";
}
