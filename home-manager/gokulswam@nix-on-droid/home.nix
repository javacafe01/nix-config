{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index

    (import ./../../home-manager/shared/programs/bat)
    (import ./../../home-manager/shared/programs/direnv)
    (import ./../../home-manager/shared/programs/eza)
    (import ./../../home-manager/shared/programs/fzf)
    (import ./../../home-manager/shared/programs/git {inherit lib pkgs;})
    (import ../shared/programs/nixvim {inherit inputs lib pkgs;})
    (import ./../../home-manager/shared/programs/starship)
    (import ./../../home-manager/shared/programs/zsh {inherit config pkgs;})
  ];

  home.stateVersion = "24.05";

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    ssh.enable = true;
  };
}
