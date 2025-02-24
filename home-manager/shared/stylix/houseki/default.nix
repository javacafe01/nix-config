{
  inputs,
  pkgs,
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    image = ../../../../assets/wall.jpg;

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

        /*
        extraCss = with config.lib.stylix.colors; ''
          tabbox {
            background-color: #${base00};
          }

          tabbox tab:selected {
            background-color: #${base01};
          }
        '';
        */

        flatpakSupport.enable = true;
      };

      nixcord.enable = true;

      nixvim = {
        enable = true;

        transparentBackground = {
          main = true;
          signColumn = true;
        };
      };

      vim.enable = true;
    };
  };
}
