{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "framework";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
      wifi.macAddress = "random";
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [
        22000
        21027
      ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "false";
      FallbackDNS = [
        "10.30.0.7"
        "1.1.1.1"
      ];
    };
  };

}
