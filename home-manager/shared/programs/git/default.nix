{
  lib,
  pkgs,
  ...
}: {
  programs.gh = {
    enable = true;

    extensions = lib.attrValues {
      inherit
        (pkgs)
        gh-cal
        gh-dash
        gh-eco
        ;
    };

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
    };
  };

  programs.git = {
    enable = true;
    userName = "Gokul Swaminathan";
    userEmail = "gokulswamilive@gmail.com";

    extraConfig.core.editor = "nvim";
  };
}
