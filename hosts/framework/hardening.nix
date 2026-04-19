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
      storage = "volatile"; # Store logs in memory
      upload.enable = false; # Disable remote log upload (the default)
      extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
    };
  };

  nix-mineral = {
    enable = true;
    filesystems.enable = false;
  };

  #boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_hardened; #conflicts with hibernation

  environment.systemPackages = with pkgs; [
    kernel-hardening-checker
  ];

  security = {
    protectKernelImage = false; # needed for hibernation
    lockKernelModules = false; # TODO enable if taislcale userland networking is possible

    forcePageTableIsolation = true;

    allowUserNamespaces = true;
    unprivilegedUsernsClone = true;
    chromiumSuidSandbox.enable = true;

    allowSimultaneousMultithreading = true;
  };

}
