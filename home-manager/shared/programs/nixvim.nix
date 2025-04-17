{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    extraPlugins = lib.attrValues {
      inherit
        (pkgs.vimPlugins)
        mini-nvim
        ;
    };

    opts = {
      number = true;
    };
  };
}
