{
  config,
  pkgs,
  ...
}:
{

  wayland.windowManager.niri.extraConfig = ''
    cursor {
        xcursor-theme "${config.stylix.cursor.name}"
        xcursor-size ${toString config.stylix.cursor.size}
        hide-when-typing
        hide-after-inactive-ms 3000
    }

    input {
        keyboard {
            xkb { }
            numlock
        }
        touchpad {
            tap
            natural-scroll
            accel-speed 0.2
            accel-profile "flat"
            click-method "clickfinger"
            scroll-factor 0.5
        }
        mouse {
            accel-profile "flat"
        }
        focus-follows-mouse max-scroll-amount="0%"
    }

    output "eDP-1" {
        scale 1.3
        position x=1920 y=0
    }

    output "DP-9" {
        mode "1920x1080@144.013"
        position x=0 y=0
    }

    output "DP-10" {
        mode "1920x1080@144.013"
        position x=0 y=0
    }

    layout {
        gaps 8
        center-focused-column "never"
        always-center-single-column
        default-column-width { proportion 0.5; }
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        focus-ring {
            width 2
            active-color "#${config.lib.stylix.colors.base0D}"
            inactive-color "#${config.lib.stylix.colors.base02}"
            urgent-color "#${config.lib.stylix.colors.base08}"
        }
        border { off; }
        background-color "transparent" 
        empty-workspace-above-first
    }

    overview {
        zoom 0.6
        workspace-shadow {
            off
        }
    }

    blur {
        passes 3
        offset 3.0
        noise 0.02
        saturation 1.2
    }

    animations {
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }

        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }

        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }

        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }

        window-open {
            duration-ms 50
            curve "ease-out-expo"
        }

        window-close {
            duration-ms 50
            curve "ease-out-quad"
        }
    }

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    hotkey-overlay {
        skip-at-startup
    }

    gestures {
        hot-corners {
            top-left
            top-right
            bottom-left
            bottom-right
        }

        dnd-edge-view-scroll {
            trigger-width 30
            delay-ms 100
            max-speed 1500
        }

        dnd-edge-workspace-switch {
            trigger-height 30
            delay-ms 100
            max-speed 1500
        }
    }

    prefer-no-csd

    xwayland-satellite {
        path "xwayland-satellite"
    }

    environment {
        QT_QPA_PLATFORM "wayland"
        MOZ_ENABLE_WAYLAND "1"
        NIXOS_OZONE_WL "1"
        AMD_VULKAN_ICD "RADV"
        LIBVA_DRIVER_NAME "radeonsi"
    }

    window-rule {
        match app-id=".*"
        background-effect { blur true; }
        geometry-corner-radius 10
        clip-to-geometry true
    }

    window-rule {
        match app-id="^pavucontrol$"
        open-floating true
    }

    window-rule {
        match app-id="^blueman-manager$"
        open-floating true
    }

    window-rule {
        match app-id="^Lxpolkit$"
        open-floating true
    }

    window-rule {
        match app-id="^xdg-desktop-portal$"
        open-floating true
    }

    window-rule {
        match app-id="^imv$"
        open-floating true
    }

    window-rule {
        match title="^Junction$"
        open-floating true
    }

    window-rule {
        match app-id="^Mullvad VPN$"
        open-floating true
    }

    window-rule {
        match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=5 y=5 relative-to="bottom-right"
    }

    window-rule {
        match app-id="^org.keepassxc.KeePassXC$"
        block-out-from "screencast"
    }

    window-rule {
        match app-id="^chromium-browser$"
        open-maximized true
    }

    // Put swaybg inside the overview backdrop.
    layer-rule {
        match namespace="^wallpaper$"
        place-within-backdrop true
    }

    layer-rule {
        match namespace="^launcher$"
        background-effect { blur true; xray false; }
    }

    layer-rule {
        match namespace="^vicinae$"
        background-effect { blur true; xray false; }
    }

    layer-rule {
        match namespace="^waybar$"
        background-effect { blur true; }
    }

    recent-windows {
        highlight {
            active-color "#${config.lib.stylix.colors.base0D}ff"
            urgent-color "#${config.lib.stylix.colors.base08}ff"
        }
    }

    spawn-at-startup "swaync"
    spawn-at-startup "systemctl" "--user" "start" "swaybg"
    spawn-at-startup "swayosd-server"

    binds {
        Mod+Return { spawn "alacritty"; }
        Mod+Space { spawn "vicinae" "toggle"; }

        Mod+Q { close-window; }
        Mod+F { maximize-column; }
        Mod+L allow-when-locked=true { spawn "vibelock"; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+Space { toggle-window-floating; }

        Mod+Left  { focus-column-or-monitor-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-or-monitor-right; }

        Mod+Shift+Left  { move-column-left-or-to-monitor-left; }
        Mod+Shift+Down  { move-window-down-or-to-workspace-down; }
        Mod+Shift+Up    { move-window-up-or-to-workspace-up; }
        Mod+Shift+Right { move-column-right-or-to-monitor-right; }

        Mod+BracketLeft { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }
        Mod+WheelScrollRight                { focus-column-right; }
        Mod+WheelScrollLeft                 { focus-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }

        Mod+Shift+Period { move-workspace-to-monitor-right; }
        Mod+Shift+Comma  { move-workspace-to-monitor-left; }

        Print { screenshot; }
        Mod+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Escape allow-inhibiting=false { quit; }

        Mod+U { spawn "usbguard-dmenu" "vicinae" "dmenu" "--placeholder"; }
        Mod+Shift+N { spawn "swaync-client" "-t" "-sw"; }
        Mod+V { spawn-sh "vicinae deeplink vicinae://launch/clipboard/history"; }
        Mod+O { toggle-overview; }
        Mod+R { switch-preset-column-width; }
        Mod+T { toggle-column-tabbed-display; }


        XF86AudioRaiseVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume" "raise"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume" "lower"; }
        XF86AudioMute allow-when-locked=true { spawn "swayosd-client" "--output-volume" "mute-toggle"; }
        XF86AudioMicMute allow-when-locked=true { spawn "swayosd-client" "--input-volume" "mute-toggle"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }

        Mod+XF86AudioRaiseVolume { spawn "playerctl" "-p" "spotify" "volume" "0.02+"; }
        Mod+XF86AudioLowerVolume { spawn "playerctl" "-p" "spotify" "volume" "0.02-"; }

        XF86MonBrightnessUp { spawn "swayosd-client" "--brightness" "raise"; }
        XF86MonBrightnessDown { spawn "swayosd-client" "--brightness" "lower"; }
        XF86KbdBrightnessUp { spawn "brightnessctl" "-d" "platform::kbd_backlight" "set" "+10%"; }
        XF86KbdBrightnessDown { spawn "brightnessctl" "-d" "platform::kbd_backlight" "set" "10%-"; }
    }
  '';

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Swaybg wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image} -m fill";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
