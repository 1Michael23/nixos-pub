{
  pkgs,
  inputs,
  ...
}:

{
  programs.opencode = {
    enable = true;

    # OpenCode 2 rewrites cli.json from the TUI. Keep the declarative layer in
    # home-manager*.json so Home Manager and OpenCode do not fight over the
    # same files.
    mutableSettings = true;

    package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

    extraPackages = [ pkgs.nodejs ];

    themes.opencode-transparent = ./opencode-transparent.json;

    settings = {
      update = "disable";
      share = "manual";

      permissions = [
        {
          action = "edit";
          resource = "*";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "*";
          effect = "ask";
        }
        {
          action = "webfetch";
          resource = "*";
          effect = "ask";
        }
        {
          action = "websearch";
          resource = "*";
          effect = "ask";
        }
        {
          action = "read";
          resource = "*";
          effect = "allow";
        }
        {
          action = "glob";
          resource = "*";
          effect = "allow";
        }
        {
          action = "grep";
          resource = "*";
          effect = "allow";
        }
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

      plugins = [
        "@tarquinen/opencode-dcp@latest"
      ];

      mcp = {
        servers = {
          nixos = {
            type = "local";
            command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
          };
        };
      };
    };

    cli = {
      theme.name = "opencode-transparent";
      attention.notifications = true;
    };
  };
}
