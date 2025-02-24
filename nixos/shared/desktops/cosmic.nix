{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  nixpkgs = {
    overlays = [
      inputs.nixpkgs-f2k.overlays.stdenvs

      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  environment = {
    variables.NIXOS_OZONE_WL = "1";
    sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    systemPackages = pkgs.lib.attrValues {
      inherit
        (pkgs)
        nautilus
        wl-clipboard
        wayland-utils
        cosmic-ext-applet-clipboard-manager
        cosmic-ext-applet-emoji-selector
        cosmic-ext-tweaks
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
    desktopManager.cosmic.enable = true;
    # displayManager.cosmic-greeter.enable = true;
    gnome.sushi.enable = true;
    gvfs.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-cosmic
    ];

    config.common.default = "*";
  };
}
