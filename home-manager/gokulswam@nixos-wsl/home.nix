{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    (import ../shared/stylix/houseki {inherit config inputs pkgs;})

    (import ../shared/programs/bat)
    (import ../shared/programs/direnv)
    (import ../shared/programs/eza)
    (import ../shared/programs/fzf)
    (import ../shared/programs/git {inherit lib pkgs;})
    (import ../shared/programs/nixvim {inherit inputs lib pkgs;})
    (import ../shared/programs/starship)
    (import ../shared/programs/zsh {inherit lib pkgs;})
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

      inputs.nixpkgs-f2k.overlays.stdenvs

      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

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
        nh
        nil
        nixd
        statix
        trash-cli
        ;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "gokulswam";
  };

  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
      initExtra = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    };

    home-manager.enable = true;
  };

  systemd.user.startServices = "sd-switch";
  targets.genericLinux.enable = false;
}
