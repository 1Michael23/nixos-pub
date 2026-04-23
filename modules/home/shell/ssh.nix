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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
}
