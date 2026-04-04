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
  ];

  environment.systemPackages = with pkgs; [
    powertop
    libratbag
    piper
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtw88
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

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

  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  systemd.sleep.extraConfig = ''
    SuspendState=mem
    HibernateDelaySec=2m
  '';

  services.solaar = {
    enable = true;
    package = pkgs.solaar;
    window = "hide";
    batteryIcons = "regular";
    extraArgs = "";
  };

  services.ratbagd.enable = true;

  environment.etc."libratbag/logitech-g502-x-plus.device".text = ''
    [Device]
    Name=Logitech G502 X Plus
    DeviceMatch=usb:046d:c099
    Driver=hidpp20
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

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

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
    libratbag
    logitech-udev-rules
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

  security.chromiumSuidSandbox.enable = true;

}
