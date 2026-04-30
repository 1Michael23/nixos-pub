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
    share = "disabled";
    logLevel = "WARN";

    permission = {
      edit = "ask";
      bash = "ask";
      webfetch = "ask";
      websearch = "ask";
      read = "allow";
      glob = "allow";
      grep = "allow";
      list = "allow";
    };

    plugin = [
      "oc-tps"
    ];

    watcher = {
      ignore = [
        ".git"
        "node_modules"
        "target"
        "result"
        "dist"
        "build"
        ".direnv"
        "*.egg-info"
        "__pycache__"
        ".pytest_cache"
        ".mypy_cache"
      ];
    };
  };
}
