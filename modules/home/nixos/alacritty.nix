{ config, lib, pkgs, ... }:

{ 
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.96;
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Regular";
        };
        bold = {
          family = "Source Code Pro";
          style = "Bold";
        };
        italic = {
          family = "Source Code Pro";
          style = "Italic";
        };
        size = 12.0;
      };
    };
  };
}