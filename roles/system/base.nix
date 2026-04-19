{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    inputs.run0-sudo-shim.packages.${pkgs.system}.default
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

  security.sudo.enable = false; # TODO switch to run0
  services.fwupd.enable = true;
  security.allowUserNamespaces = true;

}
