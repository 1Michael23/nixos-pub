# TODO fracture this huge file into modules
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./hardening.nix
    ./secrets.nix

    ../../modules/system/services/usbguard.nix

    inputs.nix-index-database.nixosModules.nix-index
  ];

  environment.systemPackages = with pkgs; [
    powertop
    piper
    inputs.nh.packages.x86_64-linux.nh
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtw88
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    max-jobs = "auto";
    cores = 0;
    keep-outputs = true;
    keep-derivations = true;
    auto-optimise-store = true;
    download-buffer-size = 268435456;

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    persistent = true;
  };

  nix.optimise.automatic = true;

  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;

  boot.initrd.luks.devices = {
    cryptswap = {
      device = "/dev/disk/by-uuid/ad86da8e-163e-49b1-a995-c644083b2aba";
      allowDiscards = true;
    };
    cryptroot = {
      device = "/dev/disk/by-uuid/9d569fca-69ea-4d85-a2f1-ce9a09959d9c";
      allowDiscards = true;
    };
  };

  swapDevices = [ { device = "/dev/mapper/cryptswap"; } ];
  boot.resumeDevice = "/dev/mapper/cryptswap";

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };

  services.solaar = {
    enable = true;
    package = pkgs.solaar;
    window = "hide";
    batteryIcons = "regular";
    extraArgs = "";
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 X Plus disable hi-res scroll]
    MatchName=*G502 X PLUS*
    MatchUdevType=mouse
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

  hardware.framework.laptop13.audioEnhancement.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.fprintd.enable = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="5", RUN+="/run/current-system/systemd/bin/systemctl hibernate"
    KERNEL=="renderD*", GROUP="render", MODE="0660"
    KERNEL=="card*",   GROUP="video",  MODE="0660"
    KERNEL=="kfd",     GROUP="render", MODE="0660"

    # Keychron Q1 HE (HID access for WebHID)
    SUBSYSTEM=="hidraw", MODE="0666"
  '';

  services.udev.packages = with pkgs; [
    logitech-udev-rules
    keychron-udev-rules
  ];

  users.mutableUsers = true;
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "render"
      "libvirtd"
      "wireshark"
      "dialout"
    ];

    shell = pkgs.fish;
  };

}
