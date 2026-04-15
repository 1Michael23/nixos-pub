{
  config,
  pkgs,
  lib,
  ...
}:

{

  home.packages = with pkgs; [
    sway
    swaybg
    waybar
    alacritty
    fuzzel
    grim
    slurp
    sway-contrib.grimshot
    wl-clipboard
    swayosd
    autotiling-rs
    brightnessctl
    mako
    pavucontrol
    playerctl
    junction
  ];

  imports = [
    ../../modules/home/desktop/sway/sway.nix
    ../../modules/home/desktop/waybar/waybar.nix
    ../../modules/home/desktop/fuzzel.nix
    ../../modules/home/desktop/alacritty.nix
    ../../modules/home/services/tailscale-tray.nix
  ];

}
