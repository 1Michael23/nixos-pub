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
    vicinae
    grim
    slurp
    sway-contrib.grimshot
    wl-clipboard
    autotiling-rs
    swayosd
    brightnessctl
    pavucontrol
    playerctl
    junction
  ];

  imports = [
    ../../modules/home/desktop/sway/sway.nix
    ../../modules/home/desktop/waybar/waybar.nix
    ../../modules/home/desktop/vicinae.nix
    ../../modules/home/desktop/alacritty.nix
    ../../modules/home/desktop/swaync.nix
    ../../modules/home/services/tailscale-tray.nix
    ../../modules/home/theme/stylix.nix
    ../../modules/home/desktop/vesktop.nix
  ];

}
