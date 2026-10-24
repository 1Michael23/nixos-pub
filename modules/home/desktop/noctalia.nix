{
  config,
  ...
}:

let
  home = config.home.homeDirectory;
  wallpaperFallback = "${./wallpapers/default.jpg}";
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
        mode = "auto";
        shell_mode = "follow";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        sync_color_scheme = true;

        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "gtk3"
            "gtk4"
            "alacritty"
            "niri"
          ];
          enable_community_templates = false;
        };
      };

      wallpaper = {
        enabled = true;
        directory = "${home}/Pictures/wallpapers";
        fill_mode = "crop";
        transition = [ "fade" ];
        transition_duration = 1500;
        transition_on_startup = true;

        default.path = wallpaperFallback;
      };

      location = {
        latitude = -33.8688;
        longitude = 151.2093;
      };

      weather = {
        enabled = true;
        unit = "metric";
      };

      bar = {
        order = [ "default" ];

        default = {
          position = "top";
          enabled = true;
          thickness = 34;
          background_opacity = 1.0;
          compositor_blur = true;
          margin_ends = 100;
          radius = 12;
          shadow = true;

          start = [ "workspaces" ];
          center = [ "active_window" ];
          end = [
            "cpu"
            "ram"
            "temp"
            "network"
            "battery"
            "power_profile"
            "volume"
            "clock"
            "tray"
            "control-center"
            "caffeine"
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

        caffeine = {
          type = "caffeine";
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
      };

      lockscreen_widgets = {
        enabled = true;
        widget_order = [
          "clock_edp"
          "clock_dp9"
          "clock_dp10"
        ];

        widget = {
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
        enabled = true;
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

  # Issue #4652: Noctalia may not exit on SIGTERM during shutdown.
  # This caps the wait; it does not fix the hang.
  systemd.user.services.noctalia.Service.TimeoutStopSec = "5s";
}
