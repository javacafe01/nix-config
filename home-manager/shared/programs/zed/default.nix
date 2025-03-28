{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "make" "lua"];

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
          provider = "copilot_chat";
          model = "gpt-4o";
        };
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

        detect_venv.on = {
          directories = [".env" "env" ".venv" "venv"];
          activate_script = "default";
        };

        env = {
          TERM = "alacritty";
        };

        # font_family = "monospace";
        # font_features = null;
        # font_size = null;
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
        lua-language-server = {
          binary = {
            path = lib.getExe pkgs.lua-language-server;
          };
        };

        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };

        rust-analyzer = {
          binary = {
            path = lib.getExe pkgs.rust-analyzer;
          };
        };
      };

      languages = {
        lua = {
          formatter = {
            external = {
              command = "${lib.getBin pkgs.stylua}";
              arguments = [
                "--syntax=Lua54"
                "--respect-ignores"
                "--stdin-filepath"
                "{buffer_path}"
                "-"
              ];
            };
          };
        };

        nix = {
          formatter = {
            external = {
              command = "${lib.getBin pkgs.alejandra}";
              arguments = ["{buffer_path}"];
            };
          };
        };
      };

      vim_mode = false;
      load_direnv = "shell_hook";
      base_keymap = "VSCode";
      show_whitespaces = "none";
    };
  };
}
