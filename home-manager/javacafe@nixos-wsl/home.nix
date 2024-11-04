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

    (import ../shared/programs/bat {})
    (import ../shared/programs/direnv {inherit config;})
    (import ../shared/programs/discord {inherit config pkgs;})
    (import ../shared/programs/eza {})
    (import ../shared/programs/fzf {})
    (import ../shared/programs/git {inherit lib pkgs;})
    (import ../shared/programs/starship {})
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

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (_final: prev: {
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

  home = {
    file = {
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
        gh
        neovim
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
      EDITOR = "${pkgs.neovim}/bin/nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe";
  };

  programs.home-manager.enable = true;

  stylix = {
    enable = true;
    autoEnable = false;
    image = ./assets/wall.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-95.yaml";
    
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
