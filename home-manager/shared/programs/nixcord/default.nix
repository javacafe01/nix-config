{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = true;

    config = {
      plugins.themeAttributes.enable = true;
      useQuickCss = true;
    };

    discord = {
      package = pkgs.discord;
      vencord.unstable = false;
    };

    quickCss = pkgs.lib.readFile ./quickCss.css;
  };
}
