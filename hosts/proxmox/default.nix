{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./disko.nix

    ./hardware-configuration.nix
    ./networking.nix
    ./secrets.nix
  ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  users.mutableUsers = true;
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

}
