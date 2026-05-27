{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/proxmox.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets."airvpn-wg" = { };
  };
}
