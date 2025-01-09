{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "make"];

    userSettings = {
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;
        ### PROVIDER OPTIONS
        ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
        ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
        ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };

        #                inline_alternatives = [
        #                    {
        #                        provider = "copilot_chat";
        #                        model = "gpt-3.5-turbo";
        #                    }
        #                ];
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      hour_format = "hour12";
      auto_update = false;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";

        detect_venv = {
          on = {
            directories = [".env" "env" ".venv" "venv"];
            activate_script = "default";
          };
        };

        env = {
          TERM = "alacritty";
        };

        font_family = "Terminess Nerd Font Mono";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";

        toolbar = {
          title = true;
        };

        working_directory = "current_project_directory";
      };

      lsp = {
        rust-analyzer = {
          binary = {
            path = lib.getExe pkgs.rust-analyzer;
          };
        };

        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
      };

      languages = {
        nix = {
          formatter = {
            external = {
              command = "${lib.getBin pkgs.alejandra}";
              arguments = ["{buffer_path}"];
            };
          };
        };
      };

      vim_mode = true;
      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      theme = {
        mode = "dark";
        light = "Rosé Pine Dawn";
        dark = "Ayu Dark";
      };

      show_whitespaces = "none";
      ui_font_size = 12;
      buffer_font_size = 12;
    };
  };
}
