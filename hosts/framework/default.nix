{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./storage.nix
    ./wireguard.nix
    ./hardening.nix
    ./llama.nix
    ./secrets.nix
    ../../roles/system/desktop-niri.nix
    ../../modules/system/virtualization/libvirtd.nix
    ../../modules/system/browsers.nix
    ../../modules/system/services/usbguard.nix
    ../../modules/system/theme/fonts.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-mineral.nixosModules.nix-mineral
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  home-manager.users.michael = import ../../users/michael/home.nix;

  home-manager.extraSpecialArgs = {
    inherit inputs;
    tf2Nix = inputs.tf2-nix;
    firefox-addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
    vscodeExtensions = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
  };

  system.stateVersion = "25.05";

  environment.systemPackages = with pkgs; [
    powertop
    sbctl
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

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

    # The 760M has only a 512 MiB UMA carveout and the desktop sits near it, so
    # the kernel put some scanout buffers in GTT. Those scanned out as solid
    # white while the cursor plane kept working and screenshots were correct;
    # only a reboot cleared it. Force scanout buffers into visible VRAM.
    kernelParams = [ "amdgpu.sg_display=0" ];
  };

  # Force one swap unit; hardware-configuration.nix also declares this by UUID.
  swapDevices = lib.mkForce [ { device = "/dev/mapper/cryptswap"; } ];

  # Compressed RAM swap on top of the LUKS swapfile, so short memory spikes
  # are absorbed without touching the disk.
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

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

  systemd = {
    # Noctalia launches apps as systemd services, so let oomd kill the
    # offending app slice (e.g. llama.cpp) instead of the whole session.
    oomd.enableUserSlices = true;

    sleep.settings.Sleep = {
      HibernateDelaySec = "45min";
      SuspendEstimationSec = "20min";
    };

    services.battery-charge-limit = {
      description = "Cap battery charge at 80%";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      unitConfig.ConditionPathExists = "/sys/class/power_supply/BAT1/charge_control_end_threshold";
      serviceConfig.Type = "oneshot";
      script = "echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold";
    };
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandlePowerKey = "suspend-then-hibernate";
      HandleSuspendKey = "suspend";
      HandleHibernateKey = "hibernate";
      HandlePowerKeyLongPress = "hibernate";
    };

    blueman.enable = true;

    fprintd.enable = true;
    fwupd.enable = true;

    power-profiles-daemon.enable = true;

    udev = {
      extraRules = ''
        SUBSYSTEM=="power_supply", KERNEL=="BAT*", ATTR{status}=="Discharging", ATTR{capacity}=="5", RUN+="/run/current-system/systemd/bin/systemctl hibernate"
        KERNEL=="renderD*", GROUP="render", MODE="0660"
        KERNEL=="card*",   GROUP="video",  MODE="0660"
        KERNEL=="kfd",     GROUP="render", MODE="0660"

        # Keychron Q1 HE (HID access for WebHID); scope to the vendor so other
        # raw HID devices are not exposed to every user.
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess"
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
    framework = {
      laptop13.audioEnhancement.enable = true;
    };
    sane.enable = true; # scanning support
    amdgpu.opencl.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
    };
    wireshark.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    solaar = {
      enable = true;
      userService.enable = true;
    };
  };

  powerManagement = {
    enable = true;
    resumeCommands = ''
      if [ -w /sys/class/power_supply/BAT1/charge_control_end_threshold ]; then
        echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold
      fi
    '';
  };

  users.mutableUsers = true;
  users.users.michael = {
    isNormalUser = true;
    uid = 1000; # keep the CIFS/NFS mounts below stable across rebuilds
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "render"
      "libvirtd"
      "wireshark"
      "dialout"
      "scanner"
      "lp" # printing stuff
    ];

    shell = pkgs.fish;
  };

}
