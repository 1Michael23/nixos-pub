{ config, pkgs, ... }:
{
  # Noctalia's built-in qt template writes the two noctalia.conf colour schemes;
  # these settings point qt5ct/qt6ct at them.
  #
  # QT_QPA_PLATFORMTHEME must be qt6ct, not qt5ct: Wireshark and OBS are Qt6
  # and qt5ct cannot theme them.
  qt = {
    enable = true;

    platformTheme = {
      name = "qt6ct";
      package = pkgs.qt6Packages.qt6ct;
    };

    qt5ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt5ct/colors/noctalia.conf";
      style = "Fusion";
    };

    qt6ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
      style = "Fusion";
    };
  };
}
