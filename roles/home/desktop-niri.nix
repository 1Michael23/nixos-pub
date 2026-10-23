{
  pkgs,
  ...
}:
{
  wayland.windowManager.niri.enable = true;

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
    ../../modules/home/desktop/niri/niri.nix
    ../../modules/home/desktop/waybar/waybar-niri.nix
    ../../modules/home/desktop/vicinae.nix
    ../../modules/home/desktop/vesktop.nix
    ../../modules/home/desktop/alacritty.nix
    ../../modules/home/desktop/swaync.nix
    #../../modules/home/services/tailscale-tray.nix #TODO broken until trayscale 0.21.0 merged anyway https://github.com/NixOS/nixpkgs/pull/576958
    ../../modules/home/theme/stylix.nix
  ];
}
