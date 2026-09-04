{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.frigate;
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      onnxruntime = pkgs.onnxruntime.override { cudaSupport = true; };
    };
    cudaCapabilities = [ "6.1" ]; # Pascal (Quadro P5000)
  };

  services.frigate = {
    enable = true;
    hostname = "_";
    checkConfig = true;
    settings = {
      detectors.onnx = {
        type = "onnx";
        device = "cuda:0";
      };

      ffmpeg.hwaccel_args = "preset-nvidia";

      mqtt = {
        enabled = true;
        host = "127.0.0.1";
      };

      database.path = "/var/lib/frigate/frigate.db";

      record = {
        enabled = true;
        retain.days = 7;
        alerts_retain.days = 30;
        detections_retain.days = 30;
      };
      snapshots.enabled = true;
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [{
      address = "0.0.0.0";
      port = 1883;
      settings = { allow_anonymous = true; };
    }];
  };

  users.users.frigate.extraGroups = [ "video" "render" ];

  systemd.services.frigate.serviceConfig.DeviceAllow = lib.mkAfter [
    "/dev/nvidia0 rw"
    "/dev/nvidiactl rw"
    "/dev/nvidia-uvm rw"
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/media/frigate 0750 frigate frigate -"
    "d /mnt/media/frigate/recordings 0750 frigate frigate -"
    "d /mnt/media/frigate/clips 0750 frigate frigate -"
    "d /mnt/media/frigate/exports 0750 frigate frigate -"
  ];

  systemd.services.frigate.requires = lib.mkAfter [ "mnt-media.mount" ];
  systemd.services.frigate.after = lib.mkAfter [ "mnt-media.mount" ];

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    80    # Frigate nginx WebUI
    8554  # Frigate RTSP restream
    8555  # Frigate WebRTC
    1883  # MQTT (Home Assistant)
  ];
}
