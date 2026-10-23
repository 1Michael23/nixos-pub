{
  pkgs,
  ...
}:
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
        name = "matugen";
        icon_theme = "auto";
      };
      light = {
        name = "matugen";
        icon_theme = "auto";
      };
    };
    pixmap_cache_mb = 50;
    favorites = [ "clipboard:history" ];
    fallbacks = [ "files:search" ];
  };

}
