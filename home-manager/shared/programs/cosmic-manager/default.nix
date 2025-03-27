{
  inputs,
  pkgs,
  ...
}: let
  cosmic-pkgs = inputs.nixos-cosmic.packages.${pkgs.system};
in {
  imports = [
    inputs.cosmic-manager.homeManagerModules.cosmic-manager

    ./cosmic2nix_generated.nix
  ];

  programs = {
    cosmic-applibrary = {
      enable = true;
      package = cosmic-pkgs.cosmic-applibrary;
    };

    cosmic-manager.enable = true;
  };
}
