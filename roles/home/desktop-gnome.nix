{
  config,
  pkgs,
  lib,
  ...
}:

{

  home.packages = with pkgs; [
    gnome-tweaks
    dconf-editor
  ];

  imports = [
    ../../modules/home/desktop/chromium.nix
    ../../modules/home/services/tailscale-tray.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      #font-name = "Source Code Pro 11";
      #monospace-font-name = "Source Code Pro 12";
      enable-animations = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium-browser.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Terminal.desktop"
      ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
      speed = -0.3;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
  };

}
