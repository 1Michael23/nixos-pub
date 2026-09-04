{
  config,
  pkgs,
  lib,
  ...
}:

{
  stylix.targets = {
    waybar.enable = true;
    swaync.enable = true;
    bat.enable = true;
    neovim.enable = true;
    zed.enable = true;
    starship.enable = true;
    mpv.enable = true;
    gdu.enable = true;
    vesktop.enable = true;
    firefox.enable = true;
    gtk.enable = true;
    qt.enable = true;
    alacritty.enable = false;
    btop.enable = false;
    fish.enable = false;
    vscodium.enable = false;
    opencode.enable = false;
  };
}
