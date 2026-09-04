{
  inputs,
  pkgs,
  ...
}:

{
  services.vibelock = {
    enable = true;
    package = inputs.vibelock.packages.${pkgs.system}.default;
    pamServiceName = "vibelock";
    startAtLogin = false;
    beforeSleep = true;
    theme = {
      preset = null;
      package = null;
      name = null;
      overrides = { };
      palette = { };
    };
    systemInfo = {
      enable = true;
    };
    clock = {
      enable = true;
      format = "%H:%M:%S";
      color = "aaaacc";
      fontSize = 100.0;
    };
    stylix.enable = true;
  };
}
