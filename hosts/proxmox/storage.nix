_: {
  # /mnt/media is the nixarr mediaDir. It is mounted at boot because nixarr
  # creates its library directories there during activation; keep it a plain
  # remote mount so those directories land on the NAS, not on the local disk.
  fileSystems."/mnt/media" = {
    device = "10.30.0.22:/mnt/nas/media";
    fsType = "nfs";
    options = [
      "noatime"
      "hard"
      "vers=4.2"
      "timeo=600"
      "retrans=2"
      "_netdev"
      "nosuid"
      "nodev"
    ];
  };

  # General NAS share. It is not needed at boot, so it is an automount: nothing
  # depends on the NAS (or the route to it) being up during boot or switch, and
  # it unmounts again after 10 minutes idle. `hard` keeps a dropped connection
  # from surfacing mid-write EIO; timeo/retrans (deciseconds) cap how long a
  # stalled access waits before retrying.
  fileSystems."/mnt/nas" = {
    device = "10.30.0.22:/mnt/nas/nas";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
      "hard"
      "timeo=100"
      "retrans=3"
      "_netdev"
      "nofail"
      "nosuid"
      "nodev"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10m"
      "x-systemd.mount-timeout=30"
    ];
  };
}
