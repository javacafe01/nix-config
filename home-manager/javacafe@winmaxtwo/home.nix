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
    inputs.stylix.homeManagerModules.stylix

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    (import ../shared/xsession/awesome {inherit lib pkgs;})

    (import ../shared/programs/alacritty {inherit config;})
    (import ../shared/programs/bat {})
    (import ../shared/programs/direnv {inherit config;})
    (import ../shared/programs/discord {inherit config pkgs;})
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
            user_pref("full-screen-api.ignore-widgets", true);
            user_pref("media.ffmpeg.vaapi.enabled", true);
            user_pref("media.rdd-vpx.enabled", true);
            user_pref("extensions.pocket.enabled", false);
          '';
        };
      };
    })

    (import ../shared/programs/fzf {})
    (import ../shared/programs/git {inherit lib pkgs;})
    (import ../shared/services/picom)
    (import ../shared/programs/starship {})
    (import ../shared/programs/vscode {inherit inputs pkgs;})

    (import ../shared/programs/zsh {
      inherit config pkgs;
      colorIt = true;
    })
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nur.overlay

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (_final: prev: {
        awesome = inputs.nixpkgs-f2k.packages.${_final.system}.awesome-luajit-git;
        picom = inputs.nixpkgs-f2k.packages.${_final.system}.picom-git;
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
      # Amazing Phinger Icons
      ".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";

      # Bin Scripts
      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ../shared/bin/updoot.nix {inherit pkgs;};
      };

      ".local/bin/panes" = {
        executable = true;
        text = import ../shared/bin/panes.nix {};
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
        gh
        neovim
        playerctl
        trash-cli
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

    sessionVariables = {
      BROWSER = "${pkgs.firefox}/bin/firefox";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe";
  };

  programs = {
    home-manager.enable = true;
    mpv.enable = true;
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    playerctld.enable = true;
  };

  stylix = {
    enable = true;
    autoEnable = false;
    image = ./assets/wall.jpg;

    base16Scheme = {
      scheme = "javacafe";
      author = "javacafe01";
      base00 = "131a21";
      base01 = "f9929b";
      base02 = "9ce5c0";
      base03 = "fbdf90";
      base04 = "a3b8ef";
      base05 = "ccaced";
      base06 = "9ce5c0";
      base07 = "ffffff";
      base08 = "3b4b58";
      base09 = "fca2aa";
      base0A = "a5d4af";
      base0B = "fbeab9";
      base0C = "bac8ef";
      base0D = "d7c1ed";
      base0E = "c7e5d6";
      base0F = "eaeaea";
    };

    fonts = {
      emoji = {
        name = "Blobmoji";
        package = pkgs.noto-fonts-emoji-blob-bin;
      };

      monospace = {
        name = "Terminess Nerd Font Mono";
        package = pkgs.nerdfonts.override {fonts = ["Terminus"];};
      };

      sansSerif = {
        name = "Sarasa Term K";
        package = pkgs.sarasa-gothic;
      };

      sizes = {
        applications = 8;
        terminal = 8;
      };
    };

    polarity = "dark";

    targets = {
      alacritty.enable = false;
      bat.enable = true;
      fzf.enable = true;

      gtk = {
        enable = true;

        extraCss = ''
          vte-terminal {
            padding: 40px;
          }
        '';
      };

      vim.enable = true;
      xresources.enable = true;
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
