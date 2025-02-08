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
    (import ../shared/programs/eza {})
    (import ../shared/programs/fzf {})

    (import ../shared/programs/ghostty {
      # Use the included homemanager nixGL wrapper script to run ghostty
      package = config.lib.nixGL.wrap pkgs.ghostty;
    })

    (import ../shared/programs/git {inherit pkgs lib;})
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

      inherit
      (pkgs.nerd-fonts)
      iosevka;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe";
  };

  # Allows us to use nixGL with a homemanager install not on NixOS
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = ["mesa" "nvidiaPrime"];

  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
      initExtra = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    };

    home-manager.enable = true;
    mpv.enable = true;
    nix-index-database.comma.enable = true;
  };

  systemd.user.startServices = "sd-switch";
  targets.genericLinux.enable = true;
}
