{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."ssh_authorized_keys" = {
      sopsFile = ../../secrets/common.yaml;
    };
  };
}
