{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    theme = "system";
    autoupdate = false;
    permission = {
      edit = "ask";
      bash = "ask";
    };
  };
}
