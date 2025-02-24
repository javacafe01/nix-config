{
  inputs,
  pkgs,
}: {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = true;

    config = {
      plugins.themeAttributes.enable = true;
      useQuickCss = false;
    };

    discord = {
      package = pkgs.discord-canary;
      vencord.unstable = true;
    };

    quickCss = ''
      @import "https://raw.githack.com/GeopJr/DNOME/dist/DNOME.css";
    '';
  };
}
