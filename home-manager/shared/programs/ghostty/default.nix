{package, ...}: {
  programs.ghostty = {
    inherit package;

    enable = true;
    enableZshIntegration = true;

    settings = {
      command = "~/.nix-profile/bin/zsh";
      cursor-style = "underline";
      cursor-style-blink = true;
      font-size = 11;
      font-family = "Iosevka Nerd Font Mono";
      window-padding-x = 20;
      window-padding-y = 20;
      theme = "carbonfox";
    };
  };
}
