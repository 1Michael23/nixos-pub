{
  config,
  ...
}:
{

  wayland.windowManager.niri.extraConfig = ''
    include optional=true "${config.xdg.configHome}/niri/noctalia.kdl"

    cursor {
        xcursor-theme "${config.home.pointerCursor.name}"
        xcursor-size ${toString config.home.pointerCursor.size}
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

        // eDP-1's top-left corner is the same seam as the ASUS top-right;
        // disable it so crossing monitors along the top edge does not open
        // the overview.
        hot-corners {
            off
        }
    }

    // The dock's MST hub renumbers its stream connector (DP-9..DP-12) on
    // every hotplug, so match the panel by make/model/serial, not connector
    // name.
    output "ASUSTek COMPUTER INC ASUS VP249 0x00036BA4" {
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

    hotkey-overlay {
        skip-at-startup
    }

    gestures {
        hot-corners {
            top-left
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

    // Keep the theme-owned backgrounds opaque; let niri composite the whole
    // window slightly transparent so its blurred backdrop shows through.
    window-rule {
        match app-id="^codium$"
        opacity 0.9
        draw-border-with-background false
    }

    window-rule {
        match app-id=r#"^(org\.gnome\.Nautilus|nautilus|[Tt]hunar)$"#
        opacity 0.9
        draw-border-with-background false
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
        match app-id=r#"^proton\.vpn\.app\.gtk$"#
        open-floating true
    }

    window-rule {
        match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=5 y=5 relative-to="bottom-right"
    }

    window-rule {
        match app-id="^org.keepassxc.KeePassXC$"
        block-out-from "screen-capture"
    }

    window-rule {
        match app-id="^chromium-browser$"
        open-maximized true
    }

    // Keep the wallpaper visible through niri's overview (stationary mode).
    layer-rule {
        match namespace="^noctalia-wallpaper"
        place-within-backdrop true
    }

    // Noctalia publishes blur regions for its surfaces; disable xray so the
    // blur samples windows rather than the wallpaper.
    layer-rule {
        match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
        background-effect { xray false; }
    }

    layer-rule {
        match namespace="noctalia-window-switcher"
        background-effect { blur true; xray false; }
    }

    window-rule {
        match app-id="dev.noctalia.Noctalia"
        open-floating true
        default-column-width { fixed 1080; }
        default-window-height { fixed 920; }
    }

    debug {
        honor-xdg-activation-with-invalid-serial
        // Promoting a fullscreen video buffer to the primary plane flashed
        // white on both panels. Only scan out buffers whose format matches
        // the composition swapchain, so client buffers keep going through
        // composition.
        restrict-primary-scanout-to-matching-format
    }

    switch-events {
        lid-close {
            spawn "noctalia" "msg" "session" "lock";
        }
    }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+Return hotkey-overlay-title="Terminal" { spawn "alacritty"; }
        Mod+Space hotkey-overlay-title="Launcher" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
        Mod+Period hotkey-overlay-title="Emoji picker" { spawn "noctalia" "msg" "panel-toggle" "launcher" "/emo"; }
        Mod+W hotkey-overlay-title="Wallpaper" { spawn "noctalia" "msg" "panel-toggle" "wallpaper"; }
        Mod+N hotkey-overlay-title="Toggle DND" { spawn "noctalia" "msg" "notification-dnd-toggle"; }
        Mod+Shift+C hotkey-overlay-title="Caffeine" { spawn "noctalia" "msg" "caffeine-toggle"; }
        Mod+U hotkey-overlay-title="USBGuard" { spawn "usbguard-dmenu" "noctalia" "dmenu" "-p"; }
        Mod+V hotkey-overlay-title="Clipboard" { spawn "noctalia" "msg" "panel-toggle" "clipboard"; }
        Mod+S hotkey-overlay-title="Control center" { spawn "noctalia" "msg" "panel-toggle" "control-center"; }
        Mod+Comma hotkey-overlay-title="Noctalia settings" { spawn "noctalia" "msg" "settings-toggle"; }
        Mod+Shift+E hotkey-overlay-title="Session menu" { spawn "noctalia" "msg" "panel-toggle" "session"; }
        Mod+Alt+L hotkey-overlay-title="Lock" { spawn "noctalia" "msg" "session" "lock"; }
        Alt+Tab hotkey-overlay-title="Window switcher" { spawn "noctalia" "msg" "window-switcher" "hold"; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Mod+Ctrl+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }

        Mod+Q repeat=false { close-window; }
        Mod+F { maximize-column; }
        Mod+M { maximize-window-to-edges; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+Shift+Space { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        Mod+T { toggle-column-tabbed-display; }
        Mod+O repeat=false { toggle-overview; }
        Mod+C { center-column; }
        Mod+Ctrl+C { center-visible-columns; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+Left  { focus-column-or-monitor-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-or-monitor-right; }
        Mod+H { focus-column-or-monitor-left; }
        Mod+J { focus-window-or-workspace-down; }
        Mod+K { focus-window-or-workspace-up; }
        Mod+L { focus-column-or-monitor-right; }
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        Mod+Shift+Left  { move-column-left-or-to-monitor-left; }
        Mod+Shift+Down  { move-window-down-or-to-workspace-down; }
        Mod+Shift+Up    { move-window-up-or-to-workspace-up; }
        Mod+Shift+Right { move-column-right-or-to-monitor-right; }
        Mod+Shift+H { move-column-left-or-to-monitor-left; }
        Mod+Shift+J { move-window-down-or-to-workspace-down; }
        Mod+Shift+K { move-window-up-or-to-workspace-up; }
        Mod+Shift+L { move-column-right-or-to-monitor-right; }
        Mod+Shift+Home { move-column-to-first; }
        Mod+Shift+End  { move-column-to-last; }

        Mod+BracketLeft { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+Tab { focus-workspace-previous; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+Period { move-workspace-to-monitor-right; }
        Mod+Shift+Comma  { move-workspace-to-monitor-left; }

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

        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }
        Mod+WheelScrollRight { focus-column-right; }
        Mod+WheelScrollLeft  { focus-column-left; }
        Mod+Shift+WheelScrollDown { focus-column-right; }
        Mod+Shift+WheelScrollUp   { focus-column-left; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Print hotkey-overlay-title="Screenshot region" { spawn "noctalia" "msg" "screenshot-region"; }
        Mod+Print hotkey-overlay-title="Screenshot fullscreen" { spawn "noctalia" "msg" "screenshot-fullscreen"; }
        Mod+Shift+Print hotkey-overlay-title="Screenshot annotate" { spawn "noctalia" "msg" "screenshot-annotate"; }
        Alt+Print { screenshot-window; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-up"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-down"; }
        XF86AudioMute allow-when-locked=true { spawn "noctalia" "msg" "volume-mute"; }
        XF86AudioMicMute allow-when-locked=true { spawn "noctalia" "msg" "mic-mute"; }
        XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
        XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }

        Mod+XF86AudioRaiseVolume hotkey-overlay-title="Spotify volume up" { spawn "playerctl" "-p" "spotify" "volume" "0.02+"; }
        Mod+XF86AudioLowerVolume hotkey-overlay-title="Spotify volume down" { spawn "playerctl" "-p" "spotify" "volume" "0.02-"; }

        XF86MonBrightnessUp allow-when-locked=true { spawn "noctalia" "msg" "brightness-up"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia" "msg" "brightness-down"; }
        XF86KbdBrightnessUp allow-when-locked=true { spawn "noctalia" "msg" "keyboard-backlight-up"; }
        XF86KbdBrightnessDown allow-when-locked=true { spawn "noctalia" "msg" "keyboard-backlight-down"; }
    }
  '';
}
