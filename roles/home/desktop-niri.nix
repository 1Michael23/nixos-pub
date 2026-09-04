{
  pkgs,
  inputs,
  ...
}: {
  programs.niri.enable = true;

  home.packages = with pkgs; [
    cliphist
    wl-clipboard
    swaybg
    swayosd
    brightnessctl
    pavucontrol
    playerctl
    junction
  ];

  imports = [
    inputs.niri.homeModules.niri
    ../../modules/home/desktop/niri/niri.nix
    ../../modules/home/desktop/waybar/waybar-niri.nix
    ../../modules/home/desktop/vicinae.nix
    ../../modules/home/desktop/vesktop.nix
    ../../modules/home/desktop/alacritty.nix
    ../../modules/home/desktop/swaync.nix
    ../../modules/home/services/tailscale-tray.nix
    ../../modules/home/theme/stylix.nix
  ];
}
