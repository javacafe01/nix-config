{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index

    (import ../shared/stylix {
      inherit config inputs pkgs;
      colorScheme = "vesper";
    })

    ../shared/programs/bat.nix
    ../shared/programs/direnv.nix
    ../shared/programs/eza.nix
    ../shared/programs/ghostty.nix
    ../shared/programs/git.nix
    ../shared/programs/nixcord.nix
    ../shared/programs/nixvim.nix
    ../shared/programs/starship.nix
    ../shared/programs/vivaldi
    ../shared/programs/vscode.nix
    ../shared/programs/zsh.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

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
      "org/gnome/shell" = {
        disable-user-extensions = false;

        enabled-extensions = with pkgs.gnomeExtensions; [
          appindicator.extensionUuid
          caffeine.extensionUuid
          dash-to-panel.extensionUuid
          pano.extensionUuid
          rounded-window-corners-reborn.extensionUuid
          tiling-assistant.extensionUuid
          vertical-workspaces.extensionUuid
        ];
      };

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
        darktable
        deadnix
        fractal
        gnome-boxes
        moonlight
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
      BROWSER = "vivaldi";
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    shell.enableShellIntegration = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "gokulswam";
  };

  programs.home-manager.enable = true;

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
