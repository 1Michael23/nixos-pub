{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    font-awesome
    jq
  ];

  programs.waybar = {
    enable = true;

    # Leave systemd disabled — sway launches waybar via its `bars` directive.
    systemd.enable = false;

    style = lib.mkForce ''
      @define-color base00 #${config.lib.stylix.colors.base00};
      @define-color base01 #${config.lib.stylix.colors.base01};
      @define-color base02 #${config.lib.stylix.colors.base02};
      @define-color base03 #${config.lib.stylix.colors.base03};
      @define-color base04 #${config.lib.stylix.colors.base04};
      @define-color base05 #${config.lib.stylix.colors.base05};
      @define-color base06 #${config.lib.stylix.colors.base06};
      @define-color base07 #${config.lib.stylix.colors.base07};
      @define-color base08 #${config.lib.stylix.colors.base08};
      @define-color base09 #${config.lib.stylix.colors.base09};
      @define-color base0A #${config.lib.stylix.colors.base0A};
      @define-color base0B #${config.lib.stylix.colors.base0B};
      @define-color base0C #${config.lib.stylix.colors.base0C};
      @define-color base0D #${config.lib.stylix.colors.base0D};
      @define-color base0E #${config.lib.stylix.colors.base0E};
      @define-color base0F #${config.lib.stylix.colors.base0F};

      * {
          font-family: "Source Code Pro", "Font Awesome 7 Free Solid", "Font Awesome 7 Free", "Noto Color Emoji", sans-serif;
          font-size: 14px;
      }

      window#waybar {
          background: alpha(@base00, 0.500000);
          color: @base05;
          min-height: 36px;
          padding: 4px 8px;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      tooltip {
          background: @base00;
          border: 1px solid @base0D;
          border-radius: 4px;
      }

      tooltip label {
          color: @base06;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }

      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px @base05;
      }

      #workspaces button {
          padding: 0 10px;
          background-color: transparent;
          color: @base05;
          margin: 0 2px;
          font-size: 16px;
      }

      #workspaces button:hover {
          background: rgba(255, 255, 255, 0.15);
          box-shadow: none;
      }

      #workspaces button.focused,
      #workspaces button.active {
          background-color: @base05;
          color: @base00;
          box-shadow: none;
          border-radius: 2px;
      }

      #workspaces button.focused:hover,
      #workspaces button.active:hover {
          background-color: @base05;
          color: @base00;
      }

      #workspaces button.urgent {
          background-color: @base08;
          color: @base05;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #custom-notification,
      #mpd {
          padding: 0px 10px;
          margin: 0 3px;
          border-radius: 4px;
          background-color: @base00;
          color: @base06;
          border: none;
      }

      .modules-right widget {
          margin: 0;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #mode {
          background-color: @base02;
          box-shadow: inset 0 -3px @base05;
      }

      #clock:hover,
      #battery:hover,
      #network:hover,
      #tray:hover,
      #custom-notification:hover,
      #power-profiles-daemon:hover {
          background-color: @base01;
      }

      #battery.charging,
      #battery.plugged {
          background-color: @base0B;
          color: @base00;
      }

      @keyframes blink {
          to {
              background-color: @base05;
              color: @base00;
          }
      }

      #battery.critical:not(.charging) {
          background-color: @base08;
          color: @base00;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #network {
          background-color: @base0D;
          color: @base00;
      }

      #network.disconnected {
          background-color: @base08;
          color: @base00;
      }

      #tray {
          background-color: @base0D;
          color: @base00;
      }

      #tray > .needs-attention {
          background-color: @base08;
          color: @base00;
      }

      #custom-notification.notification,
      #custom-notification.dnd-notification {
          background-color: @base0D;
          color: @base00;
      }
    '';

    settings.mainBar = {
      layer = "top";

      modules-left = [
        "sway/workspaces"
        "sway/mode"
      ];

      modules-center = [ "sway/window" ];

      modules-right = [
        "network"
        "battery"
        "power-profiles-daemon"
        "clock"
        "custom/notification"
        "tray"
      ];

      "sway/window" = {
        max-length = 50;
      };

      network = {
        format-wifi = builtins.fromJSON ''"{essid} ({signalStrength}%) \uf1eb"'';
        format-ethernet = builtins.fromJSON ''"{ipaddr}/{cidr} \uf6ff"'';
        tooltip-format = builtins.fromJSON ''"{ifname} via {gwaddr} \uf0ac"'';
        tooltip-format-wifi = builtins.fromJSON ''"{essid}\nSignal: {signalStrength}% ({signaldBm} dBm)\nFreq: {frequency} GHz\nIP: {ipaddr}/{cidr}\nGW: {gwaddr}\nUp: {bandwidthUpBytes}  Down: {bandwidthDownBytes}"'';
        tooltip-format-ethernet = builtins.fromJSON ''"{ifname}\nIP: {ipaddr}/{cidr}\nGW: {gwaddr}\nUp: {bandwidthUpBytes}  Down: {bandwidthDownBytes}"'';
        format-linked = builtins.fromJSON ''"{ifname} (No IP) \uf6ff"'';
        format-disconnected = builtins.fromJSON ''"Disconnected \uf071"'';
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      battery = {
        interval = 2;
        format = "{capacity}% {icon}";
        tooltip-format = "{power:.1f}W draw\n{capacity}% capacity\n{time} remaining\nHealth: {health}%";
        # fa-battery-empty, -quarter, -half, -three-quarters, -full
        format-icons = builtins.fromJSON ''[ "\uf244", "\uf243", "\uf242", "\uf241", "\uf240" ]'';
      };

      "power-profiles-daemon" = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        # default=tachometer, performance=bolt, balanced=balance-scale, power-saver=leaf
        format-icons = builtins.fromJSON ''
          {
            "default":      "\uf3fd",
            "performance":  "\uf0e7",
            "balanced":     "\uf24e",
            "power-saver":  "\uf06c"
          }
        '';
      };

      clock = {
        format = "{:%a %d %b %I:%M %p}";
        interval = 5;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "month";
          weeks-pos = "left";
          on-scroll = 1;
          format = {
            months = "<span color='#${config.lib.stylix.colors.base05}'><b>{}</b></span>";
            days = "<span color='#${config.lib.stylix.colors.base04}'><b>{}</b></span>";
            weeks = "<span color='#${config.lib.stylix.colors.base0C}'><b>W{}</b></span>";
            weekdays = "<span color='#${config.lib.stylix.colors.base0A}'><b>{}</b></span>";
            today = "<span color='#${config.lib.stylix.colors.base08}'><b><u>{}</u></b></span>";
          };
        };
      };

      "custom/notification" = {
        tooltip = true;
        format = "{icon}";
        format-icons = {
          notification = builtins.fromJSON ''"\uf0f3"'';
          none = builtins.fromJSON ''"\uf0f3"'';
          "dnd-notification" = builtins.fromJSON ''"\uf1f6"'';
          "dnd-none" = builtins.fromJSON ''"\uf1f6"'';
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
    };

  };
}
