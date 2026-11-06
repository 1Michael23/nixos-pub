{
  description = "NixOS and nix-darwin configuration for Michael's hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Pinned: upstream's nix/hashes.json is stale since bun.lock changed on
    # 2026-11-01, so fresh builds fail with an opencode-node_modules FOD hash
    # mismatch. Unpin once upstream updates nix/hashes.json.
    opencode.url = "github:anomalyco/opencode/bf544cd419c5f17535c0d5af929f7ecd41188320";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    tf2-nix.url = "gitlab:msyds/tf2-nix";

    usbguard-fuzzel = {
      url = "github:1Michael23/usbguard-fuzzel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
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
            nixfmt-tree
            sops
            statix
          ];
        };
      });

      apps = forAllSystems (pkgs: {
        check = {
          type = "app";
          meta.description = "Run statix, deadnix and nixfmt checks";
          program = "${
            pkgs.writeShellApplication {
              name = "check";
              runtimeInputs = with pkgs; [
                deadnix
                findutils
                nixfmt
                statix
              ];
              text = ''
                echo ">> statix"
                statix check -i 'resources/**'
                echo ">> deadnix"
                deadnix --fail --exclude resources .
                echo ">> nixfmt"
                find . -name '*.nix' -not -path './resources/*' -not -path './.git/*' -print0 \
                  | xargs -0 nixfmt --check
                echo ">> OK: lint clean"
              '';
            }
          }/bin/check";
        };

        check-eval = {
          type = "app";
          meta.description = "Evaluate all host configurations";
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
