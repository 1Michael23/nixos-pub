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
    ./nvidia.nix
    ../../modules/system/services/ollama.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

  boot.kernelModules = [ "virtio_balloon" ];

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
    trusted-users = [
      "root"
      "michael"
    ];

  };

  security.sudo = {
    enable = lib.mkForce true;
    wheelNeedsPassword = true;
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.tailscale.extraSetFlags = [ "--advertise-exit-node" ];

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  users.mutableUsers = true;
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$NqzAOzKU/.yVE4Px$E85F4VjIXf66i7s47xT14iodJg0vhNuNZac/RUU8HWPpy1Zvby3u8.bdI/aGpYWFiknhzCLwoReopOPqjXYI1/";
  };

}
