{
  config,
  lib,
  pkgs,
  ...
}:

{

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    AMD_VULKAN_ICD = "RADV";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  environment.systemPackages = with pkgs; [
    dbus

    nautilus
    adwaita-icon-theme
    file-roller
    sushi
    ffmpegthumbnailer
    poppler-utils

    networkmanagerapplet
    source-code-pro
    font-awesome

    flatpak
    gnome-software

    mesa
    vulkan-loader
    vulkan-tools

    libva-utils
  ];

  services.tumbler.enable = true; # thumbnails for nautilus

  services.gvfs.enable = true;

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.flatpak.enable = true;
  services.packagekit.enable = true;

  services.nscd.enable = true;
  security.pam.services = {
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
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
    config.common.default = [
      "gnome"
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
