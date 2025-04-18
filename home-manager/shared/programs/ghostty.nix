{
  programs.ghostty = {
    enable = true;

    settings = {
      command = "~/.nix-profile/bin/zsh";
      cursor-style = "underline";
      cursor-style-blink = true;
      window-padding-x = 20;
      window-padding-y = 20;
      window-decoration = "server";
      window-theme = "auto";
      gtk-titlebar-hide-when-maximized = true;
      adw-toolbar-style = "raised-border";
    };
  };
}
