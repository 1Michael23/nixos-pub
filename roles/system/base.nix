{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    inputs.run0-sudo-shim.packages.${pkgs.stdenv.hostPlatform.system}.default
    btop
    tlrc # tldr
    pfetch-rs
    duf
    usbutils
    pciutils
    gdu
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  imports = [
    inputs.nix-index-database.nixosModules.nix-index
    ../../modules/system/networking/tailscale.nix
    ../../modules/system/networking/ssh-server.nix
    ../../modules/system/users/authorized-keys.nix
  ];

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
  };

  security.sudo.enable = false;
  security.allowUserNamespaces = true;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

}
