{
  config,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "vicinae toggle";

      startup = [
        {
          command = "swayosd-server";
          always = true;
        }
        {
          command = "swaybg -i ${config.xdg.stateHome}/wallpaper/current -m fill";
          always = true;
        }
        {
          command = "autotiling-rs";
          always = true;
        }
        {
          command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";
        }
        {
          command = "swaync";
          always = true;
        }
      ];

      bars = [ { command = "waybar"; } ];

      keybindings = {
        "Mod4+Return" = "exec alacritty";
        "Mod4+q" = "kill";
        "Mod4+Shift+e" =
          ''exec swaynag -t warning -m "You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session." -B "Yes, exit sway" "swaymsg exit"'';
        "Mod4+space" = "exec vicinae toggle";
        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+space" = "floating toggle";
        "Mod4+f" = "fullscreen";
        "Mod4+l" = "exec vibelock";

        "Mod4+u" = "exec usbguard-dmenu vicinae dmenu --placeholder";
        "Mod4+Shift+n" = "exec swaync-client -t -sw";

        "Print" = "exec grimshot --notify savecopy screen";
        "Shift+Print" = "exec grimshot --notify savecopy area";

        "Mod4+Left" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";

        "Mod4+Shift+Left" = "move left";
        "Mod4+Shift+Down" = "move down";
        "Mod4+Shift+Up" = "move up";
        "Mod4+Shift+Right" = "move right";

        "Mod4+r" = "mode resize";

        "Mod4+greater" = "move workspace to output right";
        "Mod4+less" = "move workspace to output left";

        "Mod4+Shift+greater" = "move container to output right";
        "Mod4+Shift+less" = "move container to output left";

        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";
        "Mod4+5" = "workspace number 5";
        "Mod4+6" = "workspace number 6";
        "Mod4+7" = "workspace number 7";
        "Mod4+8" = "workspace number 8";
        "Mod4+9" = "workspace number 9";
        "Mod4+0" = "workspace number 10";

        "Mod4+Shift+1" = "move container to workspace number 1";
        "Mod4+Shift+2" = "move container to workspace number 2";
        "Mod4+Shift+3" = "move container to workspace number 3";
        "Mod4+Shift+4" = "move container to workspace number 4";
        "Mod4+Shift+5" = "move container to workspace number 5";
        "Mod4+Shift+6" = "move container to workspace number 6";
        "Mod4+Shift+7" = "move container to workspace number 7";
        "Mod4+Shift+8" = "move container to workspace number 8";
        "Mod4+Shift+9" = "move container to workspace number 9";
        "Mod4+Shift+0" = "move container to workspace number 10";

        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
        "Mod4+XF86AudioRaiseVolume" = "exec playerctl -p spotify volume 0.02+";
        "Mod4+XF86AudioLowerVolume" = "exec playerctl -p spotify volume 0.02-";
        "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "XF86AudioNext" = "exec swayosd-client --playerctl next";
        "XF86AudioPrev" = "exec swayosd-client --playerctl previous";
        "XF86AudioPlay" = "exec swayosd-client --playerctl play-pause";
        "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
        "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";
        "XF86KbdBrightnessUp" = "exec brightnessctl -d platform::kbd_backlight set +10%";
        "XF86KbdBrightnessDown" = "exec brightnessctl -d platform::kbd_backlight set 10%-";

        "Mod4+minus" = "scratchpad show";
        "Mod4+Shift+minus" = "move container to scratchpad";

        "Mod4+w" = "layout tabbed";
        "Mod4+Shift+w" = "layout stacking";
        "Mod4+e" = "layout toggle split";

        "Mod4+Shift+t" = "sticky toggle";
        "Mod4+v" = "exec vicinae deeplink vicinae://launch/clipboard/history";
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
          "h" = "resize shrink width 10px";
          "j" = "resize grow height 10px";
          "k" = "resize shrink height 10px";
          "l" = "resize grow width 10px";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "0.3";
          click_method = "clickfinger";
          dwt = "disabled";
        };
        "type:mouse" = {
          pointer_accel = "0";
          scroll_factor = "1";
        };
        "type:keyboard" = {
          xkb_numlock = "enabled";
        };
      };

      output = {
        "DP-9" = {
          mode = "1920x1080@144Hz";
          position = "0,0";
        };
        "DP-10" = {
          mode = "1920x1080@144Hz";
          position = "0,0";
        };
        "eDP-1" = {
          scale = "1.3";
          position = "1920,0";
        };
      };

      gaps = {
        inner = 5;
      };

    };

    extraConfig = ''
      default_border pixel 2
      default_floating_border none

      focus_follows_mouse yes
      mouse_warping none
      default_orientation horizontal
      workspace_auto_back_and_forth yes
      focus_wrapping workspace
      tiling_drag disable
      floating_maximum_size -1 x -1

      # Gestures
      bindgesture swipe:3:left workspace next_on_output
      bindgesture swipe:3:right workspace prev_on_output
      bindgesture swipe:3:up fullscreen toggle
      bindgesture swipe:3:down floating toggle

      # Window rules
      for_window [title="Junction"] floating enable
      for_window [title="Junction"] nofocus
      for_window [title="Mullvad VPN"] floating enable
      for_window [app_id="pavucontrol"] floating enable
      for_window [app_id="blueman-manager"] floating enable
      for_window [app_id="imv"] floating enable
      for_window [app_id="Lxpolkit"] floating enable
      for_window [class="Steam" title="notificationtoasts"] floating enable

      bindswitch lid:off output eDP-1 disable
      bindswitch lid:on output eDP-1 enable
    '';
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
