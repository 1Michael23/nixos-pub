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
    alacritty.enable = false;
    sway.enable = true;
    fuzzel.enable = true;
    btop.enable = false;
    bat.enable = true;
    fish.enable = false;
    neovim.enable = true;
    vscode.enable = false;
    zed.enable = true;
    librewolf.profileNames = [ "default" ];
    opencode.enable = false;
  };
}
