{
  config,
  ...
}:

let
  dataDir = "/var/lib/crafty";
in
{
  virtualisation = {
    podman.enable = true;

    oci-containers = {
      backend = "podman";

      containers.crafty = {
        # Fully qualified: NixOS registries.conf has no unqualified search
        # registries, so a short name fails with "did not resolve to an alias".
        image = "docker.io/arcadiatechnology/crafty-4:4.11.0";
        autoStart = true;
        environment.TZ = config.time.timeZone;
        volumes = [
          "${dataDir}/backups:/crafty/backups"
          "${dataDir}/logs:/crafty/logs"
          "${dataDir}/servers:/crafty/servers"
          "${dataDir}/config:/crafty/app/config"
          "${dataDir}/import:/crafty/import"
        ];
        # Keep the NixOS firewall in control of exposed ports and preserve
        # real client IPs for the Minecraft server.
        extraOptions = [ "--network=host" ];
      };
    };
  };

  # The image runs as a non-root user in group root. Group-writable
  # directories let it write without running the container as root.
  systemd.tmpfiles.rules = [
    "d ${dataDir} 2775 root root -"
    "d ${dataDir}/backups 2775 root root -"
    "d ${dataDir}/logs 2775 root root -"
    "d ${dataDir}/servers 2775 root root -"
    "d ${dataDir}/config 2775 root root -"
    "d ${dataDir}/import 2775 root root -"
  ];
}
