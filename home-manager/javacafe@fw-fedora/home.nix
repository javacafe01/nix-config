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
    (import ../shared/programs/bat)
    (import ../shared/programs/direnv {inherit config;})
    (import ../shared/programs/eza)

    (import ../shared/programs/firefox {
      inherit config pkgs;

      profiles = {
        myprofile = {
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            proton-pass
            ublock-origin
          ];

          id = 0;

          settings = {
            "browser.startup.homepage" = "https://gokulswami.org";
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

    (import ../shared/programs/fzf)

    (import ../shared/programs/ghostty)

    (import ../shared/programs/git {inherit pkgs lib;})
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
      inputs.nur.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (_final: prev: {
        firefox = config.lib.nixGL.wrap prev.firefox;
        ghostty = config.lib.nixGL.wrap inputs.ghostty.packages.x86_64-linux.default;
        vscode = config.lib.nixGL.wrap prev.vscode;
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

    homeDirectory = "/home/gokulswam";

    packages = lib.attrValues {
      inherit
        (pkgs)
        gh
        neovim
        nh
        trash-cli
        # Language servers
        nil
        nixd
        # Formatters
        alejandra
        # Extras
        deadnix
        statix
        ;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "gokulswam";
  };

  # Allows us to use nixGL with a homemanager install not on NixOS
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = ["mesa"];
    vulkan.enable = false;
  };

  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
      initExtra = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    };

    home-manager.enable = true;
    nix-index-database.comma.enable = true;
  };

  stylix = {
    enable = true;
    autoEnable = false;
    image = ../../assets/wall.jpg;

    base16Scheme = {
      scheme = "houseki";
      author = "BanchouBoo";
      base00 = "101010";
      base01 = "1c1c1c";
      base02 = "2e2e2e";
      base03 = "8ba2a2";
      base04 = "99cccc";
      base05 = "cbf3f3";
      base06 = "cbf3f3";
      base07 = "cbf3f3";
      base08 = "a33c3d";
      base09 = "a36a3c";
      base0A = "a3b370";
      base0B = "46a468";
      base0C = "49acaa";
      base0D = "5ca4cc";
      base0E = "bd7bb5";
      base0F = "6b292a";
    };

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
      ghostty.enable = true;

      gtk = {
        enable = true;

        extraCss = with config.lib.stylix.colors; ''
          window {
          	border-radius: unset;
          	box-shadow: unset;
          }

          window.csd {
          	border-radius: unset;
          	box-shadow: unset;
          }

          window.csd:backdrop {
          	box-shadow: unset;
          	transition: unset;
          }

          window.tiled,
          window.tiled-right,
          window.tiled-top,
          window.tiled-left,
          window.tiled-bottom {
          	border-radius: unset;
          	box-shadow: unset;
          }


          window.tiled:backdrop,
          window.tiled-right:backdrop,
          window.tiled-top:backdrop,
          window.tiled-left:backdrop,
          window.tiled-bottom:backdrop {
          	border-radius: unset;
          	box-shadow: unset;
          }

          window.solid-csd {
          	box-shadow: unset;
          	padding: unset;
          }

          window.solid-csd:backdrop {
          	box-shadow: unset;
          }

          window.ssd {
          	box-shadow: unset;
          }

          window.dialog.message,
          window.messagedialog {
          	box-shadow: unset;
          }

          window.main-page > viewport > clamp > box {
          	margin: unset;
          }

          tabbox {
            background-color: #${base00};
          }

          tabbox tab:selected {
            background-color: #${base01};
          }
        '';

        flatpakSupport.enable = true;
      };
    };
  };

  systemd.user.startServices = "sd-switch";
  targets.genericLinux.enable = true;
}
