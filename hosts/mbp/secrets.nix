{
  config,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../secrets/mbp.yaml;
    age.keyFile = "${config.users.users.michael.home}/.config/sops/age/keys.txt";
  };
}
