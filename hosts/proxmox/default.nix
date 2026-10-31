{
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
    ./storage.nix
    ./nvidia.nix
    ../../modules/system/services/media.nix
    ../../modules/system/services/crafty.nix

    inputs.disko.nixosModules.disko
    inputs.nixarr.nixosModules.default
  ];

  home-manager.users.michael = import ../../users/michael/home-server.nix;

  home-manager.extraSpecialArgs = {
    inherit inputs;
    vscodeExtensions = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
  };

  system.stateVersion = "25.05";

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
      persistent = true;
    };
  };

  users.mutableUsers = true;
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$NqzAOzKU/.yVE4Px$E85F4VjIXf66i7s47xT14iodJg0vhNuNZac/RUU8HWPpy1Zvby3u8.bdI/aGpYWFiknhzCLwoReopOPqjXYI1/";
  };

}
