{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "alacritty -e";
        prompt = "› ";
        width = 50; # % of screen width
        lines = 10; # number of rows shown
        layer = "overlay"; # stays on top in Sway
        icons-enabled = true;
        icon-theme = "Papirus-Dark";
        inner-pad = 8;
      };
      border = {
        width = 4;
        radius = 10;
      };

    };
  };
}
