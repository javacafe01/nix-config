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

  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  terminal.font = "${pkgs.nerd-fonts.terminess-ttf}/share/fonts/truetype/NerdFonts/TerminessNerdFontMono-Regular.ttf";
  user.shell = "${lib.getExe pkgs.zsh}";
}
