{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri-flake.nixosModules.niri
    inputs.nixos-cosmic.nixosModules.default

    ../scripts/start-cosmic-ext.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.niri-flake.overlays.niri
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
        swaybg
        wl-clipboard
        wayland-utils
        xwayland-satellite-unstable
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

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
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
