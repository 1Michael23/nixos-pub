{
  pkgs,
  ...
}:
{
  wayland.windowManager.niri = {
    enable = true;
    # Use the system XDG portal configuration and the patched system niri.
    portalPackage = null;
    xwaylandSatellitePackage = null;
  };

  home.packages = with pkgs; [
    pavucontrol
    playerctl
    junction
  ];

  imports = [
    ../../modules/home/desktop/niri/niri.nix
    ../../modules/home/desktop/noctalia.nix
    ../../modules/home/desktop/vesktop.nix
    ../../modules/home/desktop/alacritty.nix
    ../../modules/home/desktop/localsend.nix
    ../../modules/home/services/protonvpn.nix
  ];
}
