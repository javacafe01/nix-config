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
    userName = "javacafe";
    userEmail = "javacafe@sdf.org";

    extraConfig.core.editor = "nvim";
  };
}
