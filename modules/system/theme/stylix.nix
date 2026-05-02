{
  config,
  pkgs,
  lib,
  ...
}:

{
  stylix = {
    enable = true;

    #    image = ../../home/desktop/sway/000028930017-edit.JPG;
    image = ../../home/desktop/wallpapers/current.png;
    polarity = "dark";
    imageScalingMode = "fill";

    targets.fish.enable = false;

    fonts = {
      monospace = {
        package = pkgs.source-code-pro;
        name = "Source Code Pro";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        terminal = 12;
        desktop = 11;
        popups = 12;
        applications = 11;
      };
    };

    opacity = {
      terminal = 0.85;
      desktop = 0.5;
      popups = 0.96;
      applications = 1.0;
    };

    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };
}
