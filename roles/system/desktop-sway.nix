{
  config,
  lib,
  pkgs,
  ...
}:

{

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    AMD_VULKAN_ICD = "RADV";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  environment.systemPackages = with pkgs; [
    sway
    dbus

    nautilus
    nautilus-open-any-terminal
    file-roller

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    networkmanagerapplet
    source-code-pro
    font-awesome
    tuigreet
    piper
    swayidle

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
    wlsunset
    easyeffects
    lm_sensors

  ];

  services = {
    udev.packages = [ pkgs.swayosd ];

    gvfs.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };

    flatpak.enable = true;
    packagekit.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = true;
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
      login.fprintAuth = true; # greetd substacks login, so this enables fingerprint at login
      polkit-1.fprintAuth = true; # run0 privilege escalation
      login.enableGnomeKeyring = true; # greetd's session stack includes login
      # greetd lacks PAM_TTY, so drop login's pam_securetty rule.
      greetd.rules.auth = lib.mkForce (
        builtins.mapAttrs (_: rule: builtins.removeAttrs rule [ "name" ]) (
          builtins.removeAttrs config.security.pam.services.login.rules.auth [ "securetty" ]
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

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.sway ];
    xdgOpenUsePortal = true;
    config.common.default = [
      "wlr"
      "gtk"
    ];
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

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."com/github/stunkymonkey/nautilus-open-any-terminal" = {
          terminal = "'alacritty'";
        };
      }
    ];
  };

}
