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
    sbctl
    powertop
    libratbag
    piper
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtw88
  ];

  nixpkgs.config.allowUnfree = true;

  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  swapDevices = [ { device = "/dev/mapper/cryptswap"; } ]; # TODO let nix know i have encrypted swap
  boot.resumeDevice = "/dev/mapper/cryptswap";

  services.logind.lidSwitch = "suspend-then-hibernate"; # TODO fix hibernation
  # Hibernate on power button pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  services.solaar = {
    enable = true; # Enable the service
    package = pkgs.solaar; # The package to use
    window = "hide"; # Show the window on startup (show, *hide*, only [window only])
    batteryIcons = "regular"; # Which battery icons to use (*regular*, symbolic, solaar)
    extraArgs = ""; # Extra arguments to pass to solaar on startup
  };

  services.ratbagd.enable = true;

  environment.etc."libratbag/logitech-g502-x-plus.device".text = ''
    [Device]
    Name=Logitech G502 X Plus
    DeviceMatch=usb:046d:c099
    Driver=hidpp20
  '';

  # Suspend first
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "usbcore.autosuspend=-1"
  ];

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30
    SuspendState=mem
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

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

  # yubikey login requirements
  # environment.systemPackages = with pkgs; [ systemd libfido2 clevis tpm2-tools ];

  users.mutableUsers = true;
  users.users.framework = {
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
