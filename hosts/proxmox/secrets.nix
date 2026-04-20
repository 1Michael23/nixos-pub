{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/proxmox.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."ssh_authorized_keys" = {
      sopsFile = ../../secrets/common.yaml;
    };
  };
}
