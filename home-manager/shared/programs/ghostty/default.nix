_: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      cursor-style = "underline";
      cursor-style-blink = true;
      font-size = 10;
      font-family = "monospace";
      window-padding-x = 20;
      window-padding-y = 20;
      theme = "vesper";
    };
  };
}
