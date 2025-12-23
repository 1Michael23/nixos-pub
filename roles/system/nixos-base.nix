{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [

    btop
    neofetch
    tlrc # tldr
    usbutils

  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    ../../modules/system/common/tailscale.nix
    #../../modules/system/common/ssh-server.nix

  ];

  programs.fish.enable = true;

  security.sudo.enable = true; # TODO switch to run0
  services.fwupd.enable = true;
  security.allowUserNamespaces = true;

}
