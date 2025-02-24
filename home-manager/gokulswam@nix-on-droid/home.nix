{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (import ./../../home-manager/shared/programs/bat)
    (import ./../../home-manager/shared/programs/direnv)
    (import ./../../home-manager/shared/programs/eza)
    (import ./../../home-manager/shared/programs/fzf)
    (import ./../../home-manager/shared/programs/git {inherit lib pkgs;})
    (import ../shared/programs/nixvim {inherit inputs lib pkgs;})
    (import ./../../home-manager/shared/programs/starship)
    (import ./../../home-manager/shared/programs/zsh {inherit lib pkgs;})
  ];

  home.stateVersion = "24.05";
  programs.ssh.enable = true;
}
