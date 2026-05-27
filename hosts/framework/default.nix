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
    ../../roles/system/desktop-niri.nix
    ../../modules/system/virtualization/libvirtd.nix
    ../../modules/system/services/usbguard.nix
    inputs.stylix.nixosModules.stylix
    ../../modules/system/theme/stylix.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.run0-sudo-shim.nixosModules.default
    inputs.nix-mineral.nixosModules.nix-mineral
    inputs.solaar.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.vibelock.nixosModules.default
  ];

  home-manager.users.michael = import ../../users/michael/home.nix;

  home-manager.extraSpecialArgs = {
    inherit inputs;
    nix-mineral = {
      enable = true;
    };
    tf2Nix = inputs.tf2-nix;
    firefox-addons = inputs.firefox-addons.packages.${pkgs.system};
    vscodeExtensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  };

  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = with pkgs; [
    powertop
    piper
    sbctl
  ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelParams = [
      "mem_sleep_default=deep"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      rtw88
    ];

    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };

    initrd.luks.devices = {
      cryptswap = {
        device = "/dev/disk/by-uuid/ad86da8e-163e-49b1-a995-c644083b2aba";
        allowDiscards = true;
      };
      cryptroot = {
        device = "/dev/disk/by-uuid/9d569fca-69ea-4d85-a2f1-ce9a09959d9c";
        allowDiscards = true;
      };
    };

    resumeDevice = "/dev/mapper/cryptswap";
  };

  swapDevices = [ { device = "/dev/mapper/cryptswap"; } ];

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  nix = {
    settings = {
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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      persistent = true;
    };

    optimise.automatic = true;
  };

  systemd.sleep.settings.Sleep.HibernateDelaySec = 1800;

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandlePowerKey = "hibernate";
      HandleSuspendKey = "suspend";
      HandleHibernateKey = "hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };

    solaar = {
      enable = true;
      package = pkgs.solaar;
      window = "hide";
      batteryIcons = "regular";
      extraArgs = "";
    };

    blueman.enable = true;

    fprintd.enable = true;

    power-profiles-daemon.enable = true;

    udev = {
      extraRules = ''
        SUBSYSTEM=="power_supply", KERNEL=="BAT*", ATTR{status}=="Discharging", ATTR{capacity}=="5", RUN+="/run/current-system/systemd/bin/systemctl hibernate"
        KERNEL=="renderD*", GROUP="render", MODE="0660"
        KERNEL=="card*",   GROUP="video",  MODE="0660"
        KERNEL=="kfd",     GROUP="render", MODE="0660"

        # Keychron Q1 HE (HID access for WebHID)
        SUBSYSTEM=="hidraw", MODE="0666"
      '';
      packages = with pkgs; [
        logitech-udev-rules
        keychron-udev-rules
      ];
    };
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 X Plus disable hi-res scroll]
    MatchName=*G502 X PLUS*
    MatchUdevType=mouse
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';

  hardware = {
    bluetooth = {
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

    framework.laptop13.audioEnhancement.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

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
