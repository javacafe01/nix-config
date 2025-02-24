{
  lib,
  pkgs,
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      cat = "${lib.getExe pkgs.bat} --color always --plain";
      grep = "grep --color=auto";
      c = "clear";
      rm = "${pkgs.trash-cli}/bin/trash-put";
    };

    initExtra = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      set -k
      setopt auto_cd
      setopt NO_NOMATCH   # disable some globbing

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
