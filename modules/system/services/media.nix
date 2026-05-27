{
  config,
  pkgs,
  lib,
  ...
}:

{
  nixarr = {
    enable = true;
    mediaDir = "/mnt/media";
    stateDir = "/var/lib/nixarr";

    vpn = {
      enable = true;
      wgConf = config.sops.secrets.airvpn-wg.path;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 50000;
      extraSettings = {
        "peer-limit-global" = 10000;
        "peer-limit-per-torrent" = 300;
        "download-queue-enabled" = false;
        "seed-queue-enabled" = false;
        "queue-stalled-enabled" = true;
        "queue-stalled-minutes" = 30;
      };
    };

    sonarr.enable = true;
    radarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    bazarr.enable = true;

    exporters.enable = true;

    prowlarr.settings-sync.enable-nixarr-apps = true;
    sonarr.settings-sync.transmission.enable = true;
    radarr.settings-sync.transmission.enable = true;

    bazarr.settings-sync = {
      sonarr.enable = true;
      sonarr.config = {
        sync_only_monitored_series = true;
        sync_only_monitored_episodes = true;
      };
      radarr.enable = true;
      radarr.config = {
        sync_only_monitored_movies = true;
      };
    };
  };

  services.jellyfin = {
    hardwareAcceleration = {
      enable = true;
      type = "nvenc";
      device = "/dev/nvidia0";
    };
    forceEncodingConfig = true;

    transcoding = {
      enableHardwareEncoding = true;
      hardwareDecodingCodecs = {
        h264 = true;
        hevc = true;
        vp9 = true;
        av1 = true;
      };
      hardwareEncodingCodecs = {
        hevc = true;
      };
    };
  };

  services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";
  services.sonarr.settings.auth.required = "DisabledForLocalAddresses";
  services.radarr.settings.auth.required = "DisabledForLocalAddresses";
  services.lidarr.settings.auth.required = "DisabledForLocalAddresses";

  users.groups.media.gid = lib.mkForce 950;

  users.users.jellyfin.extraGroups = [
    "video"
    "render"
  ];

  systemd.services.jellyfin.serviceConfig.DeviceAllow = lib.mkAfter [
    "/dev/nvidia0 rw"
    "/dev/nvidiactl rw"
    "/dev/nvidia-uvm rw"
  ];

  users.users.michael.extraGroups = [ "media" ];

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      8096 # Jellyfin
      9091 # Transmission
      8989 # Sonarr
      7878 # Radarr
      8686 # Lidarr
      9696 # Prowlarr
      6767 # Bazarr
    ];
  };

  fileSystems."/mnt/media" = {
    device = "10.30.0.22:/mnt/nas/media";
    fsType = "nfs";
    options = [
      "noatime"
      "hard"
      "vers=4.2"
      "timeo=600"
      "retrans=2"
    ];
  };
}
