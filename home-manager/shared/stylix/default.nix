{
  config,
  inputs,
  pkgs,
  colorScheme ? "houseki",
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix

    ./colors/${colorScheme}.nix
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    image = ./wall.webp;

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
      ghostty.enable = true;
      gnome.enable = true;

      gtk = {
        enable = true;
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

      vim.enable = true;
    };
  };
}
