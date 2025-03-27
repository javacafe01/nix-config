{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../shared/stylix/houseki

    ../shared/programs/bat
    ../shared/programs/cosmic-manager
    ../shared/programs/direnv
    ../shared/programs/eza

    (import ../shared/programs/firefox {
      profiles = {
        myprofile = {
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            proton-pass
            ublock-origin
          ];

          id = 0;

          settings = {
            "browser.startup.homepage" = "https://gokulswam.github.io/";
            "general.smoothScroll" = true;
          };

          extraConfig = ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("media.ffmpeg.vaapi.enabled", true);
            user_pref("media.rdd-vpx.enabled", true);
            user_pref("extensions.pocket.enabled", false);
            user_pref("extensions.autoDisableScopes", 0);
            user_pref("extensions.enabledScopes", 15);
            user_pref("gnomeTheme.hideSingleTab", true);
          '';
        };
      };
    })

    ../shared/programs/fzf
    ../shared/programs/ghostty
    ../shared/programs/git
    ../shared/programs/niri
    ../shared/programs/nixcord
    ../shared/programs/nixvim
    ../shared/programs/starship
    ../shared/programs/vscode
    ../shared/programs/zsh
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nur.overlays.default

      (_final: _prev: {
        ghostty = inputs.ghostty.packages.${_final.system}.default;
      })
    ];

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  fonts.fontconfig.enable = true;

  home = {
    file = {
      ".local/bin/updoot" = {
        executable = true;
        text = import ../shared/bin/updoot.nix {inherit pkgs;};
      };
    };

    homeDirectory = "/home/gokulswam";

    packages = lib.attrValues {
      inherit
        (pkgs)
        alejandra
        deadnix
        fractal
        gnome-boxes
        nh
        spot
        statix
        trash-cli
        xdg-user-dirs
        ;

      inherit
        (pkgs.luajitPackages)
        jsregexp
        ;

      inherit
        (pkgs.nodePackages_latest)
        prettier
        prettier_d_slim
        ;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "gokulswam";
  };

  programs.home-manager.enable = true;
  programs.helix.enable = true;
  programs.micro.enable = true;

  systemd.user.startServices = "sd-switch";

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };
}
