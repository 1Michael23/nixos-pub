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
    ../../modules/system/services/media.nix

    inputs.disko.nixosModules.disko
    inputs.nixarr.nixosModules.default
  ];

  home-manager.users.michael = import ../../users/michael/home-server.nix;

  home-manager.extraSpecialArgs = {
    vscodeExtensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  };

  system.stateVersion = "25.05";

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
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
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

  system.autoUpgrade = {
    enable = false;
    flake = "github:1Michael23/nixos-pub";
    dates = "04:00";
    allowReboot = true;
    persistent = true;
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
