{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.lix;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.nix-on-droid.overlays.default
    ];
  };

  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  terminal.font = "${pkgs.terminus-nerdfont}/share/fonts/truetype/NerdFonts/TerminessNerdFontMono-Regular.ttf";
  user.shell = "${pkgs.zsh}/bin/zsh";
}
