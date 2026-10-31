_:

{
  networking = {
    hostName = "proxmox";
    useDHCP = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # tailscale exit-node compatibility
      allowedTCPPorts = [
        8443 # Crafty panel
        25565 # Minecraft
      ];
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "false";
      FallbackDNS = [
        "1.1.1.1"
        "9.9.9.9"
      ];
    };
  };
}
