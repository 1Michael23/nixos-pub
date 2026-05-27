{
  config,
  pkgs,
  ...
}:
let
  c = config.lib.stylix.colors;
in
{
  home.packages = [ pkgs.vicinae ];

  systemd.user.services.vicinae = {
    Unit = {
      Description = "Vicinae Launcher Daemon";
      After = [ "graphical-session.target" ];
      Requires = [ "dbus.socket" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.vicinae}/bin/vicinae server --replace";
      ExecReload = "${pkgs.vicinae}/bin/vicinae server --replace";
      Restart = "always";
      RestartSec = 5;
      KillMode = "process";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."vicinae/config.json".text = builtins.toJSON {
    telemetry.system_info = false;
    activate_on_single_click = false;
    escape_key_behavior = "close_window";
    pop_to_root_on_close = true;
    search_files_in_root = false;
    favicon_service = "none";
    font.normal = {
      family = "auto";
      size = 11;
    };
    window = {
      compact_mode.enabled = false;
      size.width = 770;
      size.height = 480;
      layer_shell = {
        enabled = true;
        keyboard_interactivity = "exclusive";
        layer = "overlay";
      };
      border_width = 1;
      shadow_size = 12;
    };
    launcher_window = {
      opacity = 0.7;
      blur.enabled = true;
    };
    theme = {
      dark = {
        name = "Stylix";
        icon_theme = "auto";
      };
      light = {
        name = "Stylix";
        icon_theme = "auto";
      };
    };
    pixmap_cache_mb = 50;
    favorites = [ "clipboard:history" ];
    fallbacks = [ "files:search" ];
  };

  xdg.configFile."vicinae/themes/stylix.toml".text = ''
    [meta]
    name = "Stylix"
    description = "Generated from stylix base16 scheme"
    variant = "dark"
    inherits = "vicinae-dark"

    [colors.core]
    accent = "#${c.base0D}"
    accent_foreground = "#${c.base00}"
    background = "#${c.base00}"
    foreground = "#${c.base05}"
    secondary_background = "#${c.base01}"
    border = "#${c.base02}"

    [colors.main_window]
    border = "#${c.base02}"
    footer = { background = "colors.core.secondary_background" }

    [colors.settings_window]
    border = "#${c.base01}"

    [colors.accents]
    blue = "#${c.base0D}"
    green = "#${c.base0B}"
    magenta = "#${c.base0E}"
    orange = "#${c.base09}"
    red = "#${c.base08}"
    yellow = "#${c.base0A}"
    cyan = "#${c.base0C}"
    purple = "#${c.base0E}"

    [colors.text]
    default = "colors.core.foreground"
    muted = "#${c.base03}"
    danger = "#${c.base08}"
    success = "#${c.base0B}"
    placeholder = "#${c.base03}"
    selection = { background = "#${c.base0D}", foreground = "#${c.base00}" }

    [colors.text.links]
    default = "#${c.base0A}"
    visited = "#${c.base0E}"

    [colors.input]
    border = "#${c.base02}"
    border_focus = "#${c.base0D}"
    border_error = "#${c.base08}"

    [colors.button.primary]
    background = "#${c.base01}"
    foreground = "#${c.base05}"
    hover = { background = "#${c.base02}" }
    focus = { outline = "colors.core.accent" }

    [colors.list.item.hover]
    foreground = "#${c.base05}"
    secondary_foreground = "#${c.base04}"

    [colors.list.item.selection]
    background = "#${c.base02}"
    foreground = "#${c.base05}"
    secondary_background = "#${c.base01}"
    secondary_foreground = "#${c.base04}"

    [colors.grid.item]
    background = "#${c.base01}"
    hover = { outline = "#${c.base05}" }
    selection = { outline = "#${c.base05}" }

    [colors.scrollbars]
    background = "#${c.base02}"

    [colors.loading]
    bar = "#${c.base0D}"
    spinner = "#${c.base05}"
  '';
}
