{
  config,
  lib,
  pkgs,
  ...
}:

{

  home.packages = with pkgs; [
    font-awesome
    jq
  ];

  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/style.css".source = ./style.css;

}
