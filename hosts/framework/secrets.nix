# hosts/framework/secrets.nix
{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/framework.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # secrets."syncthing/device_id_mbp" = { };
    # secrets."syncthing/device_id_fedora" = { };
  };
}
