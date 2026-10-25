{
  config,
  lib,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    checkConfig = true;

    settings = {
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
        wallpaper_scheme = "m3-fruit-salad";
        sync_color_scheme = true;

        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "alacritty"
            "gtk3"
            "gtk4"
            "niri"
          ];
          enable_community_templates = true;
          community_ids = [
            "steam"
            "thunar"
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
      };

      osd = {
        enabled = true;
        position = "top_center";
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
          "clock_dp9"
          "clock_dp10"
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
              background_color = "surface_variant";
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

          clock_dp9 = {
            type = "clock";
            output = "DP-9";
            cx = 960.0;
            cy = 120.0;
            box_width = 360.0;
            box_height = 120.0;
            settings.format = "{:%I:%M %p}";
          };

          clock_dp10 = {
            type = "clock";
            output = "DP-10";
            cx = 960.0;
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
            action = "screen_off";
          };
        };
      };

      desktop_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [
          "clock_edp"
          "cpu_edp"
          "ram_edp"
          "temp_edp"
          "clock_dp9"
          "cpu_dp9"
          "ram_dp9"
          "temp_dp9"
          "clock_dp10"
          "cpu_dp10"
          "ram_dp10"
          "temp_dp10"
        ];

        widget = {
          clock_edp = {
            type = "clock";
            output = "eDP-1";
            cx = 867.5;
            cy = 1040.0;
            box_width = 360.0;
            box_height = 120.0;
            settings.format = "{:%I:%M %p}";
          };

          cpu_edp = {
            type = "sysmon";
            output = "eDP-1";
            cx = 1580.0;
            cy = 90.0;
            settings = {
              display = "gauge";
              stat = "cpu_usage";
              show_label = true;
              background = true;
            };
          };

          ram_edp = {
            type = "sysmon";
            output = "eDP-1";
            cx = 1580.0;
            cy = 140.0;
            settings = {
              display = "gauge";
              stat = "ram_pct";
              show_label = true;
              background = true;
            };
          };

          temp_edp = {
            type = "sysmon";
            output = "eDP-1";
            cx = 1580.0;
            cy = 190.0;
            settings = {
              display = "gauge";
              stat = "cpu_temp";
              show_label = true;
              background = true;
            };
          };

          clock_dp9 = {
            type = "clock";
            output = "DP-9";
            cx = 960.0;
            cy = 960.0;
            box_width = 360.0;
            box_height = 120.0;
            settings.format = "{:%I:%M %p}";
          };

          cpu_dp9 = {
            type = "sysmon";
            output = "DP-9";
            cx = 1770.0;
            cy = 90.0;
            settings = {
              display = "gauge";
              stat = "cpu_usage";
              show_label = true;
              background = true;
            };
          };

          ram_dp9 = {
            type = "sysmon";
            output = "DP-9";
            cx = 1770.0;
            cy = 140.0;
            settings = {
              display = "gauge";
              stat = "ram_pct";
              show_label = true;
              background = true;
            };
          };

          temp_dp9 = {
            type = "sysmon";
            output = "DP-9";
            cx = 1770.0;
            cy = 190.0;
            settings = {
              display = "gauge";
              stat = "cpu_temp";
              show_label = true;
              background = true;
            };
          };

          clock_dp10 = {
            type = "clock";
            output = "DP-10";
            cx = 960.0;
            cy = 960.0;
            box_width = 360.0;
            box_height = 120.0;
            settings.format = "{:%I:%M %p}";
          };

          cpu_dp10 = {
            type = "sysmon";
            output = "DP-10";
            cx = 1770.0;
            cy = 90.0;
            settings = {
              display = "gauge";
              stat = "cpu_usage";
              show_label = true;
              background = true;
            };
          };

          ram_dp10 = {
            type = "sysmon";
            output = "DP-10";
            cx = 1770.0;
            cy = 140.0;
            settings = {
              display = "gauge";
              stat = "ram_pct";
              show_label = true;
              background = true;
            };
          };

          temp_dp10 = {
            type = "sysmon";
            output = "DP-10";
            cx = 1770.0;
            cy = 190.0;
            settings = {
              display = "gauge";
              stat = "cpu_temp";
              show_label = true;
              background = true;
            };
          };
        };
      };

      dock.enabled = false;
    };
  };

  # Seed a valid VS Code theme before Noctalia first renders its own.
  home.activation.noctaliaVscodeTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    themeDir="${home}/.local/state/noctalia/vscode"
    themeFile="$themeDir/NoctaliaTheme-color-theme.json"
    run mkdir -p "$themeDir"
    if [ ! -s "$themeFile" ]; then
      run rm -f "$themeFile"
      run cp ${./noctalia/templates/vscode-fallback.json} "$themeFile"
    fi
  '';

  # Issue #4652: Noctalia may not exit on SIGTERM during shutdown.
  # This caps the wait; it does not fix the hang.
  systemd.user.services.noctalia.Service.TimeoutStopSec = "5s";
}
