{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;

    extraPackages = [ pkgs.nodejs ];

    settings = {
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

      plugin = [
        "@tarquinen/opencode-dcp@latest"
        "@howaboua/opencode-tps-counter@latest"
        "@ramtinj95/opencode-tokenscope@latest"
      ];
    };

  };
}
