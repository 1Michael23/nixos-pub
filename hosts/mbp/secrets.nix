{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/mbp.yaml;
    age.keyFile = "/Users/michael/.config/sops/age/keys.txt";

    secrets."ssh_private_key" = { };
    secrets."ssh_public_key" = { };
    secrets."ssh_authorized_keys" = {
      sopsFile = ../../secrets/common.yaml;
    };
  };
}
