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
    ../shared/programs/vscode.nix
    ../shared/programs/zsh.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

      inputs.nixpkgs-f2k.overlays.stdenvs

      (_final: _prev: {
        ghostty = config.lib.nixGL.wrap inputs.ghostty.packages.${_final.system}.default;
        vscode = config.lib.nixGL.wrap _prev.vscode;
      })
    ];

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
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

    homeDirectory = "/home/javacafe";

    packages = lib.attrValues {
      inherit
        (pkgs)
        alejandra
        darktable
        deadnix
        fractal
        gnome-boxes
        nh
        parsec-bin
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
      NIXOS_OZONE_WL = 1;
      BROWSER = "vivaldi";
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    shell.enableShellIntegration = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "javacafe";
  };

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

  systemd.user.startServices = "sd-switch";
  targets.genericLinux.enable = true;
}
