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
        font = "Source Code Pro:size=12";
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
      colors = {
        background = "1e1e2eff";
        text = "eaeaf0ff";
        match = "89b4faff";
        selection = "313244ff";
        selection-text = "ffffffff";
        border = "89b4faff";
      };
    };
  };
}
