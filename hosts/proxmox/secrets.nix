{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/proxmox.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

  };
}
