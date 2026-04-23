{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets.ssh_private_key = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  sops.secrets.ssh_public_key = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    mode = "0644";
  };

  sops.secrets.ssh_authorized_keys = {
    sopsFile = ../../../secrets/common.yaml;
    path = "${config.home.homeDirectory}/.ssh/authorized_keys";
    mode = "0600";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
}
