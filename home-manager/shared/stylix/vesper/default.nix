{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    image = ../../../../assets/wall.png;
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
      eog.enable = true;

      firefox = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = ["myprofile"];
      };

      fzf.enable = true;
      ghostty.enable = true;
      gnome.enable = true;
      gnome-text-editor.enable = true;

      gtk = {
        enable = true;

        extraCss = with config.lib.stylix.colors; ''
          .titlebar,
          .titlebar .background,
          decoration,
          window,
          window.background
          {
            border-radius: 0;
          }

          decoration,
          decoration:backdrop,
          window.background
          {
            box-shadow: none;
          }
        '';

        flatpakSupport.enable = true;
      };

      nixcord.enable = false;

      nixvim = {
        enable = true;

        transparentBackground = {
          main = true;
          signColumn = true;
        };
      };

      nushell.enable = true;
      vim.enable = true;
      tmux.enable = true;

      vscode = {
        enable = true;
        profileNames = ["default"];
      };

      xfce.enable = true;
      xresources.enable = true;
      zed.enable = true;
    };
  };
}
