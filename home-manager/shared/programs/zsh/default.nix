{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      ls = "eza";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "bat --color always --plain";
      grep = "grep --color=auto";
      c = "clear";
      v = "nvim";
      xwin = "Xephyr -br -ac -noreset -screen 1960x1600 :1";
      xdisp = "DISPLAY=:1";
      rm = "${pkgs.trash-cli}/bin/trash-put";
    };

    initExtra = ''
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      fpath+="''\${0:A:h}/${pkgs.zsh-completions}/share/zsh/site-functions/"

      set -k
      setopt auto_cd
      export PATH="''${HOME}/.local/bin:''${HOME}/go/bin:''${HOME}/.emacs.d/bin:''${HOME}/.npm/bin:''${HOME}/.cargo/bin:''${PATH}"
      setopt NO_NOMATCH   # disable some globbing

      function run() {
        nix run nixpkgs#$@
      }

      precmd() {
        printf '\033]0;%s\007' "$(dirs)"
      }

      command_not_found_handler() {
        printf 'Command not found ->\033[32;05;16m %s\033[0m \n' "$0" >&2
        return 127
      }

      export SUDO_PROMPT=$'Password for ->\033[32;05;16m %u\033[0m  '
    '';

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      save = 50000;
    };
  };
}
