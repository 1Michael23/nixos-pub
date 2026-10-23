{
  config,
  lib,
  pkgs,
  ...
}:

let
  stateDir = "${config.xdg.stateHome}/matugen";
  wallpaperLink = "${config.xdg.stateHome}/wallpaper/current";
  wallpaperDir = "${config.home.homeDirectory}/Pictures/wallpapers";
  defaultWallpaper = ../desktop/wallpapers/current.png;

  waybarTemplate = pkgs.writeText "matugen-waybar.css" ''
    @define-color base00 {{colors.surface.default.hex}};
    @define-color base01 {{colors.surface_container_low.default.hex}};
    @define-color base02 {{colors.surface_container.default.hex}};
    @define-color base03 {{colors.surface_container_high.default.hex}};
    @define-color base04 {{colors.on_surface_variant.default.hex}};
    @define-color base05 {{colors.on_surface.default.hex}};
    @define-color base06 {{colors.on_surface.default.hex}};
    @define-color base07 {{colors.on_surface.default.hex}};
    @define-color base08 {{colors.error.default.hex}};
    @define-color base09 {{colors.orange.default.hex}};
    @define-color base0A {{colors.yellow.default.hex}};
    @define-color base0B {{colors.green.default.hex}};
    @define-color base0C {{colors.cyan.default.hex}};
    @define-color base0D {{colors.primary.default.hex}};
    @define-color base0E {{colors.purple.default.hex}};
    @define-color base0F {{colors.error_container.default.hex}};
  '';

  niriTemplate = pkgs.writeText "matugen-niri.kdl" ''
    layout {
        focus-ring {
            active-color "{{colors.primary.default.hex}}"
            inactive-color "{{colors.outline_variant.default.hex}}"
            urgent-color "{{colors.error.default.hex}}"
        }
    }

    recent-windows {
        highlight {
            active-color "{{colors.primary.default.hex}}ff"
            urgent-color "{{colors.error.default.hex}}ff"
        }
    }
  '';

  swayncTemplate = pkgs.writeText "matugen-swaync.css" ''
    @define-color base00 {{colors.surface.default.hex}};
    @define-color base01 {{colors.surface_container_low.default.hex}};
    @define-color base02 {{colors.surface_container.default.hex}};
    @define-color base03 {{colors.surface_container_high.default.hex}};
    @define-color base04 {{colors.on_surface_variant.default.hex}};
    @define-color base05 {{colors.on_surface.default.hex}};
    @define-color base06 {{colors.on_surface.default.hex}};
    @define-color base07 {{colors.on_surface.default.hex}};
    @define-color base08 {{colors.error.default.hex}};
    @define-color base09 {{colors.orange.default.hex}};
    @define-color base0A {{colors.yellow.default.hex}};
    @define-color base0B {{colors.green.default.hex}};
    @define-color base0C {{colors.cyan.default.hex}};
    @define-color base0D {{colors.primary.default.hex}};
    @define-color base0E {{colors.purple.default.hex}};
    @define-color base0F {{colors.error_container.default.hex}};

    .control-center {
        background: @base00;
        color: @base05;
        border: 1px solid @base0D;
    }

    .control-center .notification-row .notification-background {
        background: @base00;
        color: @base05;
    }

    .control-center .notification-row .notification-background:hover {
        background: @base01;
    }

    .control-center .notification-row .notification-background:active {
        background: @base0F;
        color: @base05;
    }

    .notification.low {
        border: 1px solid @base03;
    }

    .notification.normal {
        border: 1px solid @base0D;
    }

    .notification.critical {
        border: 1px solid @base08;
    }

    .notification-content {
        background: @base00;
        border: 1px solid @base0D;
    }

    .notification-content .text-box .summary {
        color: @base05;
    }

    .notification-content .text-box .body {
        color: @base04;
    }

    .notification-action {
        background: @base01;
        color: @base05;
    }

    .notification-action:hover {
        background: @base01;
        color: @base05;
    }

    .notification-action:active {
        background: @base0F;
        color: @base05;
    }

    .close-button {
        background: @base08;
        color: @base00;
    }

    .close-button:hover {
        background: @base0F;
        color: @base05;
    }

    .widget-title {
        color: @base05;
    }

    .widget-title > button {
        background: @base01;
        border: 1px solid @base0D;
        color: @base05;
    }

    .widget-buttons {
        color: @base05;
    }

    .widget-dnd {
        color: @base05;
    }

    .widget-dnd > switch {
        background: @base01;
        border: 1px solid @base0D;
    }

    .widget-dnd > switch:checked {
        background: @base0F;
    }

    .widget-dnd > switch slider {
        background: @base06;
    }

    .widget-volume {
        color: @base05;
    }

    .widget-volume trough {
        background: @base01;
        border: 1px solid @base0D;
    }

    .widget-volume progress {
        background: @base0D;
    }

    .widget-mpris {
        color: @base05;
    }

    .widget-mpris .widget-mpris-player {
        background: @base01;
        border: 1px solid @base0D;
    }

    .widget-mpris .widget-mpris-player button:hover {
        background: @base01;
    }
  '';

  gtkTemplate = pkgs.writeText "matugen-gtk.css" ''
    @define-color base00 {{colors.surface.default.hex}};
    @define-color base01 {{colors.surface_container_low.default.hex}};
    @define-color base02 {{colors.surface_container.default.hex}};
    @define-color base03 {{colors.surface_container_high.default.hex}};
    @define-color base04 {{colors.on_surface_variant.default.hex}};
    @define-color base05 {{colors.on_surface.default.hex}};
    @define-color base06 {{colors.on_surface.default.hex}};
    @define-color base07 {{colors.on_surface.default.hex}};
    @define-color base08 {{colors.error.default.hex}};
    @define-color base09 {{colors.orange.default.hex}};
    @define-color base0A {{colors.yellow.default.hex}};
    @define-color base0B {{colors.green.default.hex}};
    @define-color base0C {{colors.cyan.default.hex}};
    @define-color base0D {{colors.primary.default.hex}};
    @define-color base0E {{colors.purple.default.hex}};
    @define-color base0F {{colors.error_container.default.hex}};

    @define-color theme_bg_color @base00;
    @define-color theme_fg_color @base05;
    @define-color theme_base_color @base00;
    @define-color theme_text_color @base05;
    @define-color theme_selected_bg_color @base0D;
    @define-color theme_selected_fg_color @base00;
    @define-color insensitive_bg_color @base01;
    @define-color insensitive_fg_color @base03;
    @define-color borders @base02;
    @define-color unfocused_borders @base02;
    @define-color warning_color @base0A;
    @define-color error_color @base08;
    @define-color success_color @base0B;

    @define-color accent_color @base0D;
    @define-color accent_bg_color @base0D;
    @define-color accent_fg_color @base00;
    @define-color destructive_color @base08;
    @define-color destructive_bg_color @base08;
    @define-color destructive_fg_color @base00;
    @define-color success_bg_color @base0B;
    @define-color success_fg_color @base00;
    @define-color warning_bg_color @base0A;
    @define-color warning_fg_color @base00;
    @define-color error_bg_color @base08;
    @define-color error_fg_color @base00;

    @define-color window_bg_color @base00;
    @define-color window_fg_color @base05;
    @define-color view_bg_color @base00;
    @define-color view_fg_color @base05;
    @define-color headerbar_bg_color @base01;
    @define-color headerbar_fg_color @base05;
    @define-color headerbar_border_color @base02;
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
    @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
    @define-color sidebar_bg_color @base01;
    @define-color sidebar_fg_color @base05;
    @define-color sidebar_backdrop_color @window_bg_color;
    @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_shade_color @sidebar_shade_color;
    @define-color card_bg_color @base01;
    @define-color card_fg_color @base05;
    @define-color card_shade_color rgba(0, 0, 0, 0.07);
    @define-color dialog_bg_color @base01;
    @define-color dialog_fg_color @base05;
    @define-color popover_bg_color @base01;
    @define-color popover_fg_color @base05;
    @define-color popover_shade_color rgba(0, 0, 0, 0.07);
    @define-color shade_color rgba(0, 0, 0, 0.07);
    @define-color scrollbar_outline_color @base02;
  '';

  alacrittyTemplate = pkgs.writeText "matugen-alacritty.toml" ''
    [colors.primary]
    background = "{{colors.surface.default.hex}}"
    foreground = "{{colors.on_surface.default.hex}}"

    [colors.normal]
    black = "{{colors.surface_container.default.hex}}"
    red = "{{colors.error.default.hex}}"
    green = "{{colors.green.default.hex}}"
    yellow = "{{colors.yellow.default.hex}}"
    blue = "{{colors.primary.default.hex}}"
    magenta = "{{colors.purple.default.hex}}"
    cyan = "{{colors.cyan.default.hex}}"
    white = "{{colors.on_surface.default.hex}}"

    [colors.bright]
    black = "{{colors.outline.default.hex}}"
    red = "{{colors.error_container.default.hex}}"
    green = "{{colors.green.default.hex}}"
    yellow = "{{colors.yellow.default.hex}}"
    blue = "{{colors.primary_container.default.hex}}"
    magenta = "{{colors.purple.default.hex}}"
    cyan = "{{colors.cyan.default.hex}}"
    white = "{{colors.on_surface.default.hex}}"
  '';

  vicinaeTemplate = pkgs.writeText "matugen-vicinae.toml" ''
    [meta]
    name = "Matugen"
    description = "Generated from the current wallpaper"
    variant = "dark"
    inherits = "vicinae-dark"

    [colors.core]
    accent = "{{colors.primary.default.hex}}"
    accent_foreground = "{{colors.on_primary.default.hex}}"
    background = "{{colors.surface.default.hex}}"
    foreground = "{{colors.on_surface.default.hex}}"
    secondary_background = "{{colors.surface_container_low.default.hex}}"
    border = "{{colors.outline_variant.default.hex}}"

    [colors.main_window]
    border = "{{colors.outline_variant.default.hex}}"
    footer = { background = "colors.core.secondary_background" }

    [colors.settings_window]
    border = "{{colors.outline.default.hex}}"

    [colors.accents]
    blue = "{{colors.primary.default.hex}}"
    green = "{{colors.green.default.hex}}"
    magenta = "{{colors.purple.default.hex}}"
    orange = "{{colors.orange.default.hex}}"
    red = "{{colors.error.default.hex}}"
    yellow = "{{colors.yellow.default.hex}}"
    cyan = "{{colors.cyan.default.hex}}"
    purple = "{{colors.purple.default.hex}}"

    [colors.text]
    default = "colors.core.foreground"
    muted = "{{colors.on_surface_variant.default.hex}}"
    danger = "{{colors.error.default.hex}}"
    success = "{{colors.green.default.hex}}"
    placeholder = "{{colors.outline.default.hex}}"
    selection = { background = "{{colors.primary.default.hex}}", foreground = "{{colors.on_primary.default.hex}}" }

    [colors.text.links]
    default = "{{colors.primary.default.hex}}"
    visited = "{{colors.tertiary.default.hex}}"

    [colors.input]
    border = "{{colors.outline.default.hex}}"
    border_focus = "{{colors.primary.default.hex}}"
    border_error = "{{colors.error.default.hex}}"

    [colors.button.primary]
    background = "{{colors.surface_container.default.hex}}"
    foreground = "{{colors.on_surface.default.hex}}"
    hover = { background = "{{colors.surface_container_high.default.hex}}" }
    focus = { outline = "colors.core.accent" }

    [colors.list.item.hover]
    foreground = "{{colors.on_surface.default.hex}}"
    secondary_foreground = "{{colors.on_surface_variant.default.hex}}"

    [colors.list.item.selection]
    background = "{{colors.surface_container_high.default.hex}}"
    foreground = "{{colors.on_surface.default.hex}}"
    secondary_background = "{{colors.surface_container.default.hex}}"
    secondary_foreground = "{{colors.on_surface_variant.default.hex}}"

    [colors.grid.item]
    background = "{{colors.surface_container_low.default.hex}}"
    hover = { outline = "{{colors.on_surface.default.hex}}" }
    selection = { outline = "{{colors.on_surface.default.hex}}" }

    [colors.scrollbars]
    background = "{{colors.surface_container.default.hex}}"

    [colors.loading]
    bar = "{{colors.primary.default.hex}}"
    spinner = "{{colors.on_surface.default.hex}}"
  '';

  matugenConfig = (pkgs.formats.toml { }).generate "matugen-config.toml" {
    config = {
      version_check = false;
      source_color_index = 0;
      custom_colors = {
        orange = "#ff8800";
        yellow = "#ffd700";
        green = "#00ff00";
        cyan = "#00ffff";
        purple = "#a020f0";
      };
    };

    templates = {
      waybar = {
        input_path = "${waybarTemplate}";
        output_path = "${stateDir}/waybar.css";
        post_hook = "${pkgs.procps}/bin/pkill -SIGUSR2 waybar || true";
      };

      niri = {
        input_path = "${niriTemplate}";
        output_path = "${stateDir}/niri.kdl";
      };

      swaync = {
        input_path = "${swayncTemplate}";
        output_path = "${stateDir}/swaync.css";
        post_hook = "${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true";
      };

      gtk = {
        input_path = "${gtkTemplate}";
        output_path = "${stateDir}/gtk.css";
      };

      alacritty = {
        input_path = "${alacrittyTemplate}";
        output_path = "${stateDir}/alacritty.toml";
      };

      vicinae = {
        input_path = "${vicinaeTemplate}";
        output_path = "${config.xdg.dataHome}/vicinae/themes/matugen.toml";
        post_hook = "${pkgs.systemd}/bin/systemctl --user try-restart vicinae || true";
      };
    };
  };

  wallpaper = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      matugen
      systemd
    ];
    text = ''
      wallpaper_link=${lib.escapeShellArg wallpaperLink}
      wallpaper_dir=${lib.escapeShellArg wallpaperDir}
      matugen_config=${lib.escapeShellArg (toString matugenConfig)}

      usage() {
        cat >&2 <<'EOF'
      Usage: wallpaper <command> [args]

      Commands:
        set   <path>   Set the wallpaper and regenerate colors
        pick           Select a wallpaper via a dmenu launcher
        list           List available wallpapers
        current        Show the current wallpaper path
      EOF
        exit 1
      }

      list_wallpapers() {
        if [ -d "$wallpaper_dir" ]; then
          find "$wallpaper_dir" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            -printf '%f\n' 2>/dev/null | sort
        fi
      }

      cmd_set() {
        if [ "$#" -lt 1 ] || [ -z "$1" ]; then
          usage
        fi

        local src
        src=$(readlink -f -- "$1")
        if [ ! -f "$src" ]; then
          echo "Error: file not found: $1" >&2
          exit 1
        fi

        mkdir -p "$(dirname "$wallpaper_link")"
        ln -sfn "$src" "$wallpaper_link"

        matugen image "$src" \
          --config "$matugen_config" \
          --mode dark \
          --source-color-index 0

        systemctl --user restart swaybg >/dev/null 2>&1 || true
        echo "Wallpaper set to: $src"
      }

      cmd_pick() {
        local wallpapers
        wallpapers=$(list_wallpapers)
        if [ -z "$wallpapers" ]; then
          echo "No wallpapers found in $wallpaper_dir" >&2
          exit 1
        fi

        local -a launcher
        if command -v vicinae >/dev/null 2>&1; then
          launcher=(vicinae dmenu)
        elif command -v fuzzel >/dev/null 2>&1; then
          launcher=(fuzzel --dmenu)
        elif command -v dmenu >/dev/null 2>&1; then
          launcher=(dmenu)
        elif command -v wofi >/dev/null 2>&1; then
          launcher=(wofi --dmenu)
        elif command -v rofi >/dev/null 2>&1; then
          launcher=(rofi -dmenu)
        elif command -v bemenu >/dev/null 2>&1; then
          launcher=(bemenu)
        else
          echo "No dmenu-compatible launcher found" >&2
          exit 1
        fi

        local selected
        selected=$(printf '%s\n' "$wallpapers" | "''${launcher[@]}" 2>/dev/null) || true
        [ -z "$selected" ] && exit 0
        cmd_set "$wallpaper_dir/$selected"
      }

      cmd_list() {
        list_wallpapers
      }

      cmd_current() {
        if [ -e "$wallpaper_link" ] || [ -L "$wallpaper_link" ]; then
          readlink -f "$wallpaper_link"
        else
          echo "No current wallpaper set" >&2
          exit 1
        fi
      }

      [ "$#" -eq 0 ] && usage

      case "$1" in
        set)
          shift
          cmd_set "$@"
          ;;
        pick) cmd_pick ;;
        list) cmd_list ;;
        current) cmd_current ;;
        *) usage ;;
      esac
    '';
  };
in
{
  home = {
    packages = [
      pkgs.matugen
      wallpaper
    ];

    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      gtk.enable = true;
    };

    activation.matugen = lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] ''
      stateDir=${lib.escapeShellArg stateDir}
      link=${lib.escapeShellArg wallpaperLink}

      run ${pkgs.coreutils}/bin/mkdir -p "$stateDir" \
        "$(${pkgs.coreutils}/bin/dirname "$link")"

      if [ ! -e "$link" ] && [ ! -L "$link" ]; then
        run ${pkgs.coreutils}/bin/ln -s \
          ${lib.escapeShellArg (toString defaultWallpaper)} "$link"
      fi

      target=$(${pkgs.coreutils}/bin/readlink -f "$link")
      run ${pkgs.matugen}/bin/matugen image "$target" \
        --config ${matugenConfig} \
        --mode dark \
        --source-color-index 0
    '';
  };

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      size = 11;
      package = pkgs.dejavu_fonts;
    };
    gtk3.extraCss = ''@import url("file://${stateDir}/gtk.css");'';
    gtk4.extraCss = ''@import url("file://${stateDir}/gtk.css");'';
  };
}
