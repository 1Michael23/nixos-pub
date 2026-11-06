{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  home = {
    packages = [
      pkgs.adw-gtk3
    ];

    # Seed a valid VS Code theme before Noctalia first renders its own.
    activation.noctaliaVscodeTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      themeDir="${home}/.local/state/noctalia/vscode"
      themeFile="$themeDir/NoctaliaTheme-color-theme.json"
      run mkdir -p "$themeDir"
      if [ ! -s "$themeFile" ]; then
        run rm -f "$themeFile"
        run cp ${./noctalia/templates/vscode-fallback.json} "$themeFile"
      fi
    '';
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    checkConfig = false;

    settings = {
      hooks =
        let
          ppctl = lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl";
        in
        {
          battery_discharging = "${ppctl} set power-saver";
          battery_charging = "${ppctl} set balanced";
          # Fires when plugged in but not charging, e.g. holding at the 80% cap.
          battery_plugged = "${ppctl} set balanced";
        };

      shell = {
        font_family = "sans-serif";
        setup_wizard_enabled = false;
        telemetry_enabled = false;
        polkit_agent = true;
        clipboard_enabled = true;
        time_format = "{:%I:%M %p}";
        date_format = "{:%a %d %b}";
        niri_overview_type_to_launch_enabled = true;
        settings_show_advanced = false;
        launch_apps_as_systemd_services = true;

        animation.enabled = false;

        launcher = {
          compact = true;
          default_view = "pinned";
          pinned = [
            "chromium-browser"
            "codium"
            "librewolf"
            "com.spotify.Client"
            "onlyoffice-desktopeditors"
            "com.orcaslicer.OrcaSlicer"
            "org.gnome.Nautilus"
          ];
          width = 800;
        };

        panel = {
          clipboard_position = "bottom_left";
          control_center_position = "center";
          shadow = false;
          transparency_mode = "soft";
          wallpaper_placement = "floating";
        };

        screenshot = {
          save_to_file = true;
          directory = "${home}/Pictures/Screenshots";
          filename_pattern = "screenshot_%Y%m%d_%H%M%S";
          copy_to_clipboard = true;
          freeze_screen = true;
          annotate = false;
        };
      };

      theme = {
        mode = "dark";
        shell_mode = "follow";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        sync_color_scheme = true;

        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "alacritty"
            "gtk3"
            "gtk4"
            "niri"
            "qt"
          ];
          enable_community_templates = true;
          community_ids = [
            "ungoogled-chromium"
          ];

          user.vscode = {
            input_path = "${./noctalia/templates/vscode.json}";
            output_path = "${home}/.local/state/noctalia/vscode/NoctaliaTheme-color-theme.json";
          };
        };
      };

      wallpaper = {
        enabled = true;
        directory = "${home}/Pictures/wallpapers";
        fill_mode = "crop";
        transition = [ ];
        transition_on_startup = false;

        default.path = "${home}/Pictures/wallpapers/film.png";
      };

      location = {
        latitude = -33.8688;
        longitude = 151.2093;
      };

      weather = {
        enabled = true;
        unit = "metric";
      };

      nightlight = {
        enabled = true;
        temperature_night = 4000;
      };

      brightness.enable_ddcutil = true;

      control_center = {
        hidden_tabs = [ "calendar" ];
        width = 900;
      };

      bar = {
        order = [ "default" ];

        default = {
          position = "top";
          enabled = true;
          thickness = 36;
          background_opacity = 0.7;
          compositor_blur = true;
          capsule = true;
          concave_edge_corners = false;
          margin_edge = 3;
          margin_ends = 30;
          radius = 10;
          shadow = false;
          font_scale = 1.1;

          start = [
            "workspaces"
            "cpu"
            "ram"
            "temp"
          ];
          center = [ "active_window" ];
          end = [
            "network"
            "battery"
            "power_profile"
            "clock"
            "tray"
            "control-center"
          ];
        };
      };

      widget = {
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
          show_value = true;
          show_glyph = true;
          actions.left = "exec alacritty -e btop";
        };

        ram = {
          type = "sysmon";
          stat = "ram_used";
          visualization = "none";
          show_value = true;
          show_glyph = true;
        };

        temp = {
          type = "sysmon";
          stat = "cpu_temp";
          visualization = "none";
          show_value = true;
          show_glyph = true;
        };

        clock = {
          type = "clock";
          format = "{:%a %d %b %I:%M %p}";
        };

        network = {
          vpn_status = "both";
        };

        workspaces = {
          empty_color = "on_secondary";
          focused_color = "error";
          urgent_color = "on_error";
        };
      };

      notification = {
        enable_daemon = true;
        position = "top_right";
        layer = "top";
        follow_focused_output = true;
      };

      osd = {
        enabled = true;
        position = "top_center";
        follow_focused_output = true;
      };

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
        fingerprint = true;
        blur_intensity = 1.0;
        blurred_desktop = true;
        transition_duration = 300;
      };

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "clock_edp"
        ];

        grid = {
          visible = true;
          cell_size = 16;
          major_interval = 4;
        };

        widget = {
          "lockscreen-login-box@eDP-1" = {
            type = "login_box";
            output = "eDP-1";
            cx = 868.0;
            cy = 975.0;
            box_width = 810.0;
            box_height = 196.0;
            rotation = 0.0;
            placement_width = 1735.0;
            placement_height = 1157.0;

            settings = {
              layout = "regular";
              background_color = "surface_container";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              center_password_text = false;
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_password_reveal = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };

          clock_edp = {
            type = "clock";
            output = "eDP-1";
            cx = 867.5;
            cy = 120.0;
            box_width = 360.0;
            box_height = 120.0;
            settings.format = "{:%I:%M %p}";
          };
        };
      };

      idle = {
        behavior = {
          lock = {
            enabled = true;
            timeout = 600;
            action = "lock";
          };

          "screen-off" = {
            enabled = true;
            timeout = 660;
            locked_timeout = 30; # after a manual lock, screen off in 30 s
            action = "screen_off";
          };

          # Battery only. Goes through Noctalia's session suspend, so a future
          # shell.session.power.suspend override applies here too.
          sleep = {
            enabled = true;
            timeout = 1200;
            action = "command";
            command = "${lib.getExe' pkgs.gnugrep "grep"} -q 1 /sys/class/power_supply/ACAD/online || ${lib.getExe config.programs.noctalia.package} msg session lock-and-suspend";
          };
        };
      };

      dock.enabled = false;
    };
  };

  # checkConfig only rejects fatal validation errors; Noctalia exits 0 for
  # warnings (unknown keys/enum values), so fail the build on those too.
  xdg.configFile."noctalia/config.toml".source = lib.mkForce (
    pkgs.runCommand "noctalia-config.toml" { } ''
      set -euo pipefail
      raw=${(pkgs.formats.toml { }).generate "noctalia-config.toml" config.programs.noctalia.settings}
      ${lib.getExe config.programs.noctalia.package} config validate "$raw" 2>&1 | tee validate.log
      if grep -q '^WARN' validate.log; then
        echo "Noctalia config validation produced warnings" >&2
        exit 1
      fi
      cp "$raw" "$out"
    ''
  );

  # Issue #4652: Noctalia may not exit on SIGTERM during shutdown.
  # This caps the wait; it does not fix the hang.
  systemd.user.services.noctalia.Service.TimeoutStopSec = "5s";
}
