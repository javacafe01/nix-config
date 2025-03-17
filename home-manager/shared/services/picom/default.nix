{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    shadow = false;

    settings = {
      enable-fading-next-tag = true;
      unredir-if-possible = true;
      corner-radius = 0;
      detect-rounded-corners = true;

      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
    };
  };
}
