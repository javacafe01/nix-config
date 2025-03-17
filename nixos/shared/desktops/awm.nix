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

      (_final: prev: {
        awesome = inputs.nixpkgs-f2k.packages.${_final.system}.awesome-git;
      })
    ];
  };

  environment.systemPackages = pkgs.lib.attrValues {
    inherit
      (pkgs)
      adwaita-icon-theme
      libnotify
      nautilus
      ;
  };

  programs = {
    dconf.enable = true;

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    seahorse.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
  };

  services = {
    displayManager.defaultSession = "none+awesome";
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;

      windowManager.awesome = {
        enable = true;

        luaModules = pkgs.lib.attrValues {
          inherit (pkgs.luaPackages) lgi ldbus luadbi-mysql luaposix;
        };
      };
    };

    gnome.sushi.enable = true;
    gvfs.enable = true;
  };
}
