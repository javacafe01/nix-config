{
  inputs,
  pkgs,
  ...
}: let
  marketplace-extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    koihik.vscode-lua-format
    piousdeer.adwaita-theme
    rvest.vs-code-prettier-eslint
    sndst00m.markdown-github-dark-pack
  ];
in {
  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions;
      [
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        kamadorueda.alejandra
        ms-vscode.cpptools
        mkhl.direnv
        sumneko.lua
        xaver.clang-format
      ]
      ++ marketplace-extensions;

    mutableExtensionsDir = true;

    userSettings = {
      Lua.misc.executablePath = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";

      "[c]".editor.defaultFormatter = "xaver.clang-format";
      "[cpp]".editor.defaultFormatter = "xaver.clang-format";
      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[javascript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[lua]".editor.defaultFormatter = "Koihik.vscode-lua-format";
      "[nix]".editor.defaultFormatter = "kamadorueda.alejandra";
      "[python]".editor.formatOnType = true;

      breadcrumbs.enabled = false;

      editor = {
        cursorBlinking = "smooth";
        formatOnSave = true;
        lineNumbers = "on";
        minimap.enabled = false;
        smoothScrolling = true;
        stickyScroll.enabled = false;

        bracketPairColorization = {
          enabled = true;
          independentColorPoolPerBracketType = true;
        };
      };

      jupyter.askForKernelRestart = false;
      nix.serverPath = "${pkgs.nil}/bin/nil";

      terminal.integrated = {
        cursorBlinking = true;
        cursorStyle = "line";
        smoothScrolling = true;
      };

      window = {
        menuBarVisibility = "toggle";
        nativeTabs = true;
        titleBarStyle = "custom";
      };

      workbench = {
        colorTheme = "Adwaita Dark & default syntax highlighting";
        list.smoothScrolling = true;
        smoothScrolling = true;
      };
    };
  };
}
