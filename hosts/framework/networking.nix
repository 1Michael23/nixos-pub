{ lib, ... }:

{
  networking = {
    hostName = "framework";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
      # A distinct MAC per network, but the same one on every reconnect.
      wifi.macAddress = "stable";
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };

  services = {
    # SSH is reachable over the tailnet only; tailscale0 is trusted.
    openssh.openFirewall = false;

    # Laptop routes nothing for the tailnet.
    tailscale.useRoutingFeatures = lib.mkForce "client";

    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "false";
        FallbackDNS = [
          "10.30.0.7"
          "1.1.1.1"
        ];
      };
    };
  };

}
