{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/framework.yaml;
    age.keyFile = "/home/michael/.config/sops/age/keys.txt";

    secrets."ssh_private_key" = { };
    secrets."ssh_public_key" = { };
  };
}
