{
  config,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../secrets/framework.yaml;
    age.keyFile = "${config.users.users.michael.home}/.config/sops/age/keys.txt";

    secrets = {
      "vpn-profile" = {
        restartUnits = [ "vpn-profile.service" ];
      };
      # mount.cifs credentials file for //10.30.0.22/nas (see storage.nix).
      "smb-credentials" = { };
    };
  };
}
