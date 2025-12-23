{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # TODO check redundancy
    sway
    swaybg
    waybar
    alacritty
    fuzzel
    grim
    slurp
    sway-contrib.grimshot
    wl-clipboard
    swayosd
    autotiling-rs
    brightnessctl
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "fuzzel";

      startup = [
        {
          command = "swaybg -i ${./000028930017-edit.JPG} -m stretch";
          always = true;
        }
        {
          command = "swayosd-server";
          always = true;
        }
        {
          command = "autotiling-rs";
          always = true;
        }
      ];

      bars = [ { command = "waybar"; } ];

      keybindings = {
        "Mod4+Return" = "exec alacritty";
        "Mod4+q" = "kill";
        "Mod4+Shift+e" =
          ''exec swaynag -t warning -m "You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session." -B "Yes, exit sway" "swaymsg exit"'';
        "Mod4+space" = "exec fuzzel";
        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+space" = "floating toggle";
        "Mod4+f" = "fullscreen";

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

        "XF86AudioRaiseVolume" = "exec playerctl -p spotify volume 0.02+";
        "XF86AudioLowerVolume" = "exec playerctl -p spotify volume 0.02-";
        "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
        "--release Caps_Lock" = "exec swayosd-client --caps-lock";
        "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
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
        };
      };

      output = {
        "DP-9" = {
          mode = "1920x1080@144Hz";
        };
        "DP-10" = {
          mode = "1920x1080@144Hz";
        };
        "eDP-1" = {
          scale = "1.3";
        };
      };

      gaps = {
        inner = 5;
      };
    };

    extraConfig = ''
      default_border pixel 2
      default_floating_border none

      # Lid behavior
      bindswitch lid:on  output eDP-1 disable
      bindswitch lid:off output eDP-1 enable

      # Window rules
      for_window [title="Junction"] floating enable
      for_window [title="Junction"] nofocus
      for_window [title="Mullvad VPN"] floating enable
    '';
  };

  home.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share";
  };
}
