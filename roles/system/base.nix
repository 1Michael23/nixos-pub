{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    inputs.run0-sudo-shim.packages.${stdenv.hostPlatform.system}.default
    btop
    fastfetch
    tlrc # tldr
    pfetch-rs
    duf
    usbutils
    pciutils
    gdu
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    inputs.nix-index-database.darwinModules.nix-index
    ../../modules/system/networking/tailscale.nix
    ../../modules/system/networking/ssh-server.nix
    ../../modules/system/users/authorized-keys.nix
    ../../modules/system/services/vscode-server.nix
  ];

  programs.fish.enable = true;

  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;

  security.sudo.enable = false;
  services.fwupd.enable = true;
  security.allowUserNamespaces = true;

}
