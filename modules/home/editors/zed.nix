{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;
    installRemoteServer = true;

    extensions = [
      "nix"
      "toml"
      "elixir"
      "make"
    ];

    userSettings = {
      agent = {
        enabled = false;
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      hour_format = "hour24";
      auto_update = false;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "alacritty";
        };
        font_family = "Source Code Pro";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        # shell = {
        #   program = "zsh";
        # };
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      lsp = {
        rust-analyzer = {
          binary = {
            # path = lib.getExe pkgs.rust-analyzer;
            path_lookup = true;
          };
        };

        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };

      # Tell Zed to use direnv and direnv can use a flake.nix environment
      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      format_on_save = "on";
      tab_size = 4;
      soft_wrap = "none";
      show_whitespaces = "all";

      minimap = {
        enabled = true;
      };

      project_panel = {
        dock = "left";
      };

      toolbar = {
        breadcrumbs = false;
      };

      buffer_font_size = lib.mkForce 14;
      ui_font_size = lib.mkForce 14;
    };
  };

}
