{
  config,
  lib,
  pkgs,
  ...
}:

{
  #Source: https://saylesss88.github.io/nix/hardening_NixOS.html

  users.groups.netdev = { };
  services = {
    dbus.implementation = "broker";
    logrotate.enable = true;
    journald = {
      storage = "persistent"; # TODO change to volatile
      upload.enable = false; # Disable remote log upload (the default)
      extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
    };
  };

  nix-mineral = {
    enable = true;
    settings = {
      system.multilib = true; # NOTE disable when/if steam no longer needs it
    };
    filesystems.enable = false;
  };

  # nix-mineral dropped its generic-machine-id default (now deprecated),
  # which silently removed /etc/machine-id and broke tpm2-setup, machined,
  # and libvirtd. Restore the previous id to keep secrets intact.
  environment.etc.machine-id.text = "b08dfa6083e7567a1921a715000001fb";

  # jitterentropy-rngd package ships a broken service unit:
  # 1. SystemCallFilter blocks @clock syscalls its own daemon needs (killed by SIGSYS).
  # 2. LimitMEMLOCK=0 but the jitterentropy library now calls mlock() on allocations.
  #    nix-mineral already provides system-wide hardening, so the extra seccomp is
  #    redundant. Fix both by clearing the filter and allowing memory locking.
  systemd.services.jitterentropy.serviceConfig = {
    # Use [ "" ] rather than [ ] to produce an empty SystemCallFilter= directive,
    # which is the systemd way to clear a list setting from upstream.
    SystemCallFilter = lib.mkForce [ "" ];
    # jitterentropy library 3.7+ calls mlock() in jent_zalloc().
    # Upstream package sets LimitMEMLOCK=0 for the old 1.2.x library that didn't need it.
    LimitMEMLOCK = lib.mkForce "8M";
  };

  boot.kernelModules = [ "tun" ];

  environment.systemPackages = with pkgs; [
    kernel-hardening-checker
  ];

  security = {
    protectKernelImage = false; # needed for hibernation
    lockKernelModules = true; # TODO TEMP

    forcePageTableIsolation = true;

    allowUserNamespaces = true;
    chromiumSuidSandbox.enable = true;

    allowSimultaneousMultithreading = true;
  };

}
