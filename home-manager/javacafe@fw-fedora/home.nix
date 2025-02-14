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
      scheme = "carbonfox";
      author = "EdenEast";
      base00 = "161616";
      base01 = "252525";
      base02 = "353535";
      base03 = "484848";
      base04 = "7b7c7e";
      base05 = "f2f4f8";
      base06 = "b6b8bb";
      base07 = "e4e4e5";
      base08 = "ee5396";
      base09 = "3ddbd9";
      base0A = "08bdba";
      base0B = "25be6a";
      base0C = "33b1ff";
      base0D = "78a9ff";
      base0E = "be95ff";
      base0F = "ff7eb6";
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
