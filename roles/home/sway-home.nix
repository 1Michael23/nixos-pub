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
    swayosd
    pavucontrol
    playerctl
    junction
  ];

  imports = [
    ../../modules/home/nixos/sway/sway.nix
    ../../modules/home/nixos/waybar/waybar.nix

    ../../modules/home/nixos/fuzzel.nix
    ../../modules/home/nixos/alacritty.nix

    ../../modules/home/nixos/tailscale-tray.nix
  ];

}
