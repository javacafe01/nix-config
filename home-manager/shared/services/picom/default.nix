{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = false;

    shadow = false;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.8;

    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "_PICOM_SHADOW@:32c = 0"
      "_NET_WM_WINDOW_TYPE:a = '_NET_WM_WINDOW_TYPE_NOTIFICATION'"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      "class_g = 'Conky'"
      "class_g = 'slop'"
      "window_type = 'combo'"
      "window_type = 'desktop'"
      "window_type = 'dnd'"
      "window_type = 'dock'"
      "window_type = 'dropdown_menu'"
      "window_type = 'menu'"
      "window_type = 'popup_menu'"
      "window_type = 'splash'"
      "window_type = 'toolbar'"
      "window_type = 'utility'"
    ];

    settings = {
      enable-fading-next-tag = true;
      shadow-radius = 7;
      unredir-if-possible = true;
      corner-radius = 0;
      detect-rounded-corners = true;

      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
    };

    wintypes = {
      notification.full-shadow = false;
    };
  };
}
