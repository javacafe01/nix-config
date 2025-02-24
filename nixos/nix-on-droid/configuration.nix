{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  nix.package = pkgs.lix;

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
