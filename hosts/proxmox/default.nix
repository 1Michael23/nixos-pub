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

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
    kernelModules = [ "virtio_balloon" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    tailscale.extraSetFlags = [ "--advertise-exit-node" ];
  };

  nix = {
    settings = {
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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  security.sudo = {
    enable = lib.mkForce true;
    wheelNeedsPassword = true;
  };

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
