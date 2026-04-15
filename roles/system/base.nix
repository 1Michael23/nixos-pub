{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    btop
    fastfetch
    tlrc # tldr
    usbutils
    gdu
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    ../../modules/system/networking/tailscale.nix
    ../../modules/system/networking/ssh-server.nix
  ];

  programs.fish.enable = true;

  security.sudo.enable = true; # TODO switch to run0
  services.fwupd.enable = true;
  security.allowUserNamespaces = true;

}
