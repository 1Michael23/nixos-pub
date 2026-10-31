{ config, ... }:

{
  # The NAS `nas` share used to be reached through GVFS:
  # /run/user/$UID/gvfs/smb-share:server=10.30.0.22,share=nas. Mount it with
  # the kernel CIFS client instead so the path is stable and every program
  # (not just GIO ones) sees the same file system. GVFS stays enabled for the
  # other backends (mtp, trash, Flatpak file pickers).
  # Pulls in the cifs kernel modules and puts cifs-utils (mount.cifs) in
  # system.fsPackages, so both the mount unit and manual mounts find the helper.
  boot.supportedFilesystems = [ "cifs" ];

  fileSystems."/mnt/nas" = {
    device = "//10.30.0.22/nas";
    fsType = "cifs";
    options = [
      # A credentials file, never the password itself: Nix option strings end
      # up world-readable in /etc/fstab and in the store. sops-nix installs it
      # from the stage-2 activation script here (`sops.useSystemdActivation` is
      # false: no systemd.sysusers/userborn), i.e. before any unit starts, so
      # the mount needs no ordering dependency on a sops unit.
      "credentials=${config.sops.secrets."smb-credentials".path}"
      "uid=${toString config.users.users.michael.uid}" # michael
      "gid=${toString config.users.groups.users.gid}" # users
      "vers=3.1.1"
      "seal" # the NAS negotiates SMB3 encryption
      "file_mode=0600"
      "dir_mode=0700"
      "nosuid"
      "nodev"
      # Laptop: an unreachable server must surface as EIO, not as every process
      # on the path hanging forever. `soft` is the kernel default, keep it
      # explicit so a default change cannot reintroduce the hang.
      "soft"
      "_netdev"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10m"
      "x-systemd.mount-timeout=30"
    ];
  };
}
