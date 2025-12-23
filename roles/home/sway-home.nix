{
  config,
  pkgs,
  lib,
  ...
}:

{

  home.packages = with pkgs; [
    fuzzel
    mako
    swayosd
    sway-contrib.grimshot
    wl-clipboard
    brightnessctl
    pavucontrol
    playerctl
    autotiling-rs
  ];

  imports = [
    ../../modules/home/nixos/sway/sway.nix
    ../../modules/home/nixos/waybar/waybar.nix

    ../../modules/home/nixos/fuzzel.nix
    ../../modules/home/nixos/alacritty.nix

    ../../modules/home/nixos/tailscale-tray.nix
  ];

}
