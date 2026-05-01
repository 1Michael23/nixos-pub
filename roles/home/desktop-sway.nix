#TODO find best way to organise sway config in multiple locations
# roles/home/desktop-sway.nix
# roles/system/desktop-sway.nix
# modules/home/desktop/sway/sway.nix

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
    cliphist
    alacritty
    fuzzel
    grim
    slurp
    sway-contrib.grimshot
    wl-clipboard
    swayosd
    autotiling-rs
    brightnessctl
    pavucontrol
    playerctl
    junction
  ];

  imports = [
    ../../modules/home/desktop/sway/sway.nix
    ../../modules/home/desktop/waybar/waybar.nix
    ../../modules/home/desktop/fuzzel.nix
    ../../modules/home/desktop/alacritty.nix
    ../../modules/home/desktop/swaync.nix
    ../../modules/home/services/tailscale-tray.nix
    ../../modules/home/theme/stylix.nix
  ];

}
