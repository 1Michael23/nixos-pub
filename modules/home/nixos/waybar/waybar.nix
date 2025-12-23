{
  config,
  lib,
  pkgs,
  ...
}:

{

  home.packages = with pkgs; [
    waybar
    font-awesome
    jq
  ];

  programs.waybar = {
    enable = true;
    #systemd.enable = true;
  };

  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/style.css".source = ./style.css;

}
