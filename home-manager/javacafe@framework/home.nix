# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
    inputs.stylix.homeManagerModules.stylix

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    (import ../shared/programs/bat {})
    (import ../shared/programs/direnv {inherit config;})
    # Fuck me, this doesn't work on Wayland/Niri... idk
    # (import ../shared/programs/discord {inherit config pkgs;})
    (import ../shared/programs/eza {})

    (import ../shared/programs/firefox {
      inherit config pkgs;
      package = pkgs.firefox;

      profiles = {
        myprofile = {
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            proton-pass
            ublock-origin
          ];

          id = 0;

          settings = {
            "browser.startup.homepage" = "https://javacafe01.github.io/startpage/";
            "general.smoothScroll" = true;
          };

          userChrome = import ../shared/programs/firefox/userChrome-css.nix {
            inherit config;
          };

          userContent = import ../shared/programs/firefox/userContent-css.nix {
            inherit config;
          };

          extraConfig = ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("media.ffmpeg.vaapi.enabled", true);
            user_pref("media.rdd-vpx.enabled", true);
            user_pref("extensions.pocket.enabled", false);
            user_pref("extensions.autoDisableScopes", 0);
            user_pref("extensions.enabledScopes", 15);
          '';
        };
      };
    })

    (import ../shared/programs/fzf {})

    (import ../shared/programs/ghostty {
      package = pkgs.ghostty;
    })

    (import ../shared/programs/git {inherit lib pkgs;})
    (import ../shared/programs/niri {inherit pkgs config;})
    (import ../shared/programs/starship {})
    (import ../shared/programs/vscode {inherit inputs pkgs;})

    (import ../shared/programs/zsh {
      inherit config pkgs;
      colorIt = true;
    })

    # (import ../shared/programs/zed {inherit pkgs lib;})
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nur.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (_final: prev: {
        ghostty = inputs.ghostty.packages.x86_64-linux.default;
        ripgrep = prev.ripgrep.override {withPCRE2 = true;};
      })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  fonts.fontconfig.enable = true;

  home = {
    file = {
      # Bin Scripts
      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ../shared/bin/updoot.nix {inherit pkgs;};
      };
    };

    homeDirectory = "/home/javacafe";

    packages = lib.attrValues {
      inherit
        (pkgs)
        brightnessctl
        inotify-tools
        libnotify
        pavucontrol
        fractal
        gh
        nh
        neovim
        playerctl
        trash-cli
        vesktop
        xdg-user-dirs
        # Language servers
        ccls
        clang
        clang-tools
        nil
        rust-analyzer
        shellcheck
        sumneko-lua-language-server
        # Formatters
        alejandra
        black
        ktlint
        rustfmt
        shfmt
        stylua
        # Extras
        deadnix
        editorconfig-core-c
        fd
        gnuplot
        gnutls
        imagemagick
        sdcv
        sqlite
        statix
        ripgrep
        ;

      inherit
        (pkgs.luajitPackages)
        jsregexp
        ;

      inherit
        (pkgs.nodePackages_latest)
        prettier
        prettier_d_slim
        bash-language-server
        ;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    /*
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
    };
    */

    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe";
  };

  programs = {
    fuzzel.enable = true;
    home-manager.enable = true;
    mpv.enable = true;
  };

  services = {
    # blueman-applet.enable = true;
    # network-manager-applet.enable = true;
    # playerctld.enable = true;
  };

  stylix = {
    enable = true;
    autoEnable = false;
    image = ./assets/wall.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
    };

    fonts = {
      emoji = {
        name = "Blobmoji";
        package = pkgs.noto-fonts-emoji-blob-bin;
      };

      monospace = {
        name = "Liga SFMono Nerd Font";
        package = pkgs.sfmonoNerdFontLig;
      };

      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };

      sizes = {
        applications = 10;
        terminal = 10;
      };
    };

    polarity = "dark";

    targets = {
      bat.enable = true;
      fuzzel.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      vim.enable = true;
    };
  };

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
