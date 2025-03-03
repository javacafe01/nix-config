{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    overlays = [
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

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
        rounded-window-corners-reborn
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
