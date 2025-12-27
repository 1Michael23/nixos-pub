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
    networkmanagerapplet
    source-code-pro
    font-awesome
    tuigreet
    piper

    flatpak
    gnome-software

    mesa
    vulkan-loader
    vulkan-tools

    libva-utils

  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  services.flatpak.enable = true;
  services.packagekit.enable = true;

  #programs.sway.enable = true;

  services.nscd.enable = true; # TODO wtf this do?
  security.pam.services = {
    ly.fprintAuth = false;
    login.fprintAuth = false;
    sudo.fprintAuth = true;
    polkit-1.fprintAuth = true;
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

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
    config.common.default = [
      "wlr"
      "gtk"
    ];
  };

  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

}
