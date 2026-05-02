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
        border-width = 2;
        border-radius = 12;
        inner-pad = 8;
      };

    };
  };
}
