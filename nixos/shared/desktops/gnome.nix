{
  config,
  pkgs,
  ...
}: {
  environment = {
    variables.NIXOS_OZONE_WL = "1";

    systemPackages = pkgs.lib.attrValues {
      inherit
        (pkgs)
        adwaita-icon-theme
        nautilus
        ;

      inherit
        (pkgs.gnomeExtensions)
        appindicator
        caffeine
        dash-to-panel
        pano
        rounded-window-corners-reborn
        tiling-assistant
        vertical-workspaces
        ;
    };
  };

  programs = {
    dconf.enable = true;

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    seahorse.enable = true;
  };

  services = {
    xserver = {
      desktopManager.gnome.enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    gnome.sushi.enable = true;
    gvfs.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];

    config.common.default = "*";
  };
}
