{
  pkgs,
  inputs,
  ...
}:

{
  programs.opencode = {
    enable = true;
    package =
      inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode.overrideAttrs
        (prev: {
          postPatch = (prev.postPatch or "") + ''
            # The fork's nix/node_modules.nix fileset excludes the top-level
            # script/ dir, but packages/cli/script/build.ts imports
            # ../../../script/native-arch. Copy it in from the full source.
            # Upstream fix: anomalyco/opencode#55494. Drop this once merged.
            cp -R ${inputs.opencode}/script ./script
          '';
        });

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
