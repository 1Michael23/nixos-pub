_:

{
  networking = {
    hostName = "proxmox";
    useDHCP = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # tailscale exit-node compatibility
      allowedTCPPorts = [
        22
        8096 # Jellyfin
        9091 # Transmission
        8989 # Sonarr
        7878 # Radarr
        8686 # Lidarr
        9696 # Prowlarr
        6767 # Bazarr

        8080 # openwebui

        8554 # Frigate RTSP restream
        8555 # Frigate WebRTC
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
