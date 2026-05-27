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
    sway.enable = true;
    bat.enable = true;
    neovim.enable = true;
    zed.enable = true;
    alacritty.enable = false;
    btop.enable = false;
    fish.enable = false;
    vscode.enable = false;
    opencode.enable = false;
  };
}
