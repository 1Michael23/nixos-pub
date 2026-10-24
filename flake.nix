{
  description = "Nix";

  inputs = {
    # TODO: revert to github:NixOS/nixpkgs/nixos-unstable once it contains 82139be
    # (NixOS/nixpkgs#575818, which works around the still-open #575192 .ko.cer
    # aggregation bug). The pin below already contains that fix.
    nixpkgs.url = "github:NixOS/nixpkgs/9a43e55823aec87065693b5b78092a49421177f5";

    opencode.url = "github:anomalyco/opencode";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-mineral.url = "github:cynicsketch/nix-mineral/";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    run0-sudo-shim = {
      url = "github:lordgrimmauld/run0-sudo-shim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tf2-nix.url = "gitlab:msyds/tf2-nix";

    usbguard-fuzzel.url = "path:/home/michael/dev/usbguard-fuzzel";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };

    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      sops-nix,
      nix-index-database,
      ...
    }@inputs:
    let
      mkHost = import ./lib/mkHost.nix {
        inherit
          nixpkgs
          home-manager
          sops-nix
          nix-index-database
          inputs
          ;
      };

      mkDarwinHost = import ./lib/mkDarwinHost.nix {
        inherit
          darwin
          home-manager
          sops-nix
          nix-index-database
          inputs
          ;
      };

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-darwin"
        ] (system: f nixpkgs.legacyPackages.${system});

      framework = mkHost {
        hostname = "framework";
        system = "x86_64-linux";
      };

      proxmox = mkHost {
        hostname = "proxmox";
        system = "x86_64-linux";
      };

      mbp = mkDarwinHost {
        hostname = "mbp";
      };
    in
    {
      nixosConfigurations = {
        inherit framework proxmox;
      };

      darwinConfigurations = {
        inherit mbp;
      };

      hydraJobs = {
        framework = framework.config.system.build.toplevel;
        proxmox = proxmox.config.system.build.toplevel;
        mbp = mbp.config.system.build.toplevel;
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            age
            deadnix
            nix-eval-jobs
            nixfmt
            sops
            statix
          ];
        };
      });

      apps = forAllSystems (pkgs: {
        check = {
          type = "app";
          program = "${
            pkgs.writeShellApplication {
              name = "check";
              runtimeInputs = with pkgs; [
                deadnix
                statix
              ];
              text = ''
                echo ">> statix"
                statix check
                echo ">> deadnix"
                deadnix --fail --exclude docs/refs .
                echo ">> OK: lint clean"
              '';
            }
          }/bin/check";
        };

        check-eval = {
          type = "app";
          program = "${
            pkgs.writeShellApplication {
              name = "check-eval";
              runtimeInputs = with pkgs; [
                coreutils
                gnugrep
                nix-eval-jobs
              ];
              text = ''
                set -euo pipefail
                echo ">> eval framework + proxmox + mbp (parallel)"
                out="$(mktemp)"
                trap 'rm -f "$out"' EXIT
                nix-eval-jobs --flake .#hydraJobs --workers 3 --no-instantiate --show-trace > "$out"
                if grep -q '"error"' "$out"; then
                  echo ">> FAILED: at least one host failed to evaluate (see error above)" >&2
                  exit 1
                fi
                echo ">> OK: all hosts eval"
              '';
            }
          }/bin/check-eval";
        };
      });
    };
}
