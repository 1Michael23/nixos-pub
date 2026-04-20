{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "proxmox";
    useDHCP = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # tailscale exit-node compatibility
      allowedTCPPorts = [ 22 ];
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [
      "1.1.1.1"
      "9.9.9.9"
    ];
  };
}
