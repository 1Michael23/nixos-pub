{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../../modules/system/thumbnailers.nix ];

  # TODO: Remove this overlay once nixpkgs' niri includes upstream commit
  # 4adbf003 ("niri-session: import login environment without the deprecated
  # systemd call", niri-wm/niri#4706). This is a temporary backport for 26.04.
  # https://github.com/niri-wm/niri/issues/4624
  nixpkgs.overlays = [
    (_final: prev: {
      niri = prev.niri.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace resources/niri-session \
            --replace-fail 'systemctl --user import-environment' \
              'dbus-update-activation-environment --systemd --all'
        '';
      });
    })
  ];

  environment = {
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
    };

    # The greeter discovers sessions from the system profile, not from the
    # packages' individual store paths.
    pathsToLink = [ "/share/wayland-sessions" ];

    systemPackages = with pkgs; [
      # Patched via the overlay above.
      niri
      xwayland-satellite
      dbus

      nautilus
      nautilus-open-any-terminal
      file-roller

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav

      piper

      flatpak
      gnome-software

      mesa
      vulkan-loader
      vulkan-tools

      libva-utils

      gnome-disk-utility

      mpv
      imv
      ffmpeg
      unzip
      p7zip
      unrar
      trash-cli
      wf-recorder
      easyeffects
      lm_sensors
    ];
  };

  # greetd creates the greeter user without device groups. The graphical
  # greeter needs DRM and input access to start its compositor.
  users.users.greeter.extraGroups = [
    "video"
    "render"
    "input"
  ];

  services = {
    gvfs.enable = true;

    accounts-daemon.enable = false;

    displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "Niri";
        keyboard.layout = "us";
        auth.allow_empty_password = false;
        # Match Niri's DP-9/DP-10 mode so login does not switch from the
        # greeter's 60 Hz to Niri's 144 Hz and flash the display.
        output.refresh_rate = "DP-9:144; DP-10:144; eDP-1:60";
        appearance = {
          hide_logo = true;
          power_buttons_position = "hidden";
          scheme_selector_position = "hidden";
        };
      };
    };

    flatpak.enable = true;
    packagekit.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      settings.publish."disable-publishing" = false;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    nscd.enable = true;
    upower.enable = true;

    dbus.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
  };

  security = {
    rtkit.enable = true; # PipeWire realtime scheduling
    polkit.enable = true;

    pam.services = {
      # Noctalia's lock screen uses the FPrint D-Bus API directly. Keep
      # login.fprintAuth off so pam_fprintd cannot block password unlock;
      # polkit-1 still covers run0 privilege escalation.
      polkit-1.fprintAuth = true;
      login.enableGnomeKeyring = true; # password login unlocks the keyring
      # greetd lacks PAM_TTY, so drop login's pam_securetty rule. Keep the
      # graphical greeter password-only: pam_fprintd gives PAM no password for
      # pam_gnome_keyring, which leaves the login keyring locked.
      greetd.rules.auth = lib.mkForce (
        builtins.mapAttrs (_: rule: builtins.removeAttrs rule [ "name" ]) (
          builtins.removeAttrs config.security.pam.services.login.rules.auth [
            "securetty"
            "fprintd"
          ]
        )
      );
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      mesa
      libva-vdpau-driver
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi # optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings."com/github/stunkymonkey/nautilus-open-any-terminal" = {
            terminal = "'alacritty'";
          };
          settings."org/gnome/nautilus/preferences" = {
            show-image-thumbnails = "always";
            thumbnail-limit = lib.gvariant.mkUint64 100;
          };
        }
      ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.niri ];
    xdgOpenUsePortal = true;
    config.common = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
    ];

    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono" ];
      sansSerif = [ "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };

}
