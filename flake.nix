# flake.nix
{
  description = "Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tf2-nix.url = "gitlab:msyds/tf2-nix";
  };

  outputs =
    inputs@{
      nixpkgs,
      darwin,
      mac-app-util,
      home-manager,
      sops-nix,
      ...
    }:
    let
      mkHost = import ./lib/mkHost.nix {
        inherit
          nixpkgs
          home-manager
          sops-nix
          inputs
          ;
      };

      mkDarwinHost = import ./lib/mkDarwinHost.nix {
        inherit
          darwin
          home-manager
          sops-nix
          inputs
          ;
      };
    in
    {
      nixosConfigurations.framework = mkHost {
        hostname = "framework";
        system = "x86_64-linux";
        secureBoot = true;

        users.michael = ./users/michael/home.nix;

        extraSpecialArgs = {
          tf2Nix = inputs.tf2-nix;
          firefox-addons = inputs.firefox-addons.packages.x86_64-linux;
          vscodeExtensions = inputs.nix-vscode-extensions.extensions.x86_64-linux;
        };

        modules = [
          ./roles/system/desktop-sway.nix
          #./roles/system/desktop-gnome.nix
          ./modules/system/virtualization/libvirtd.nix
          inputs.solaar.nixosModules.default
        ];
      };

      darwinConfigurations.mbp = mkDarwinHost {
        hostname = "mbp";
        users.michael = ./users/michael/home.nix;
        modules = [
          inputs.mac-app-util.darwinModules.default
        ];
        extraSpecialArgs = {
          inherit inputs;
          vscodeExtensions = inputs.nix-vscode-extensions.extensions.aarch64-darwin;
        };
      };
    };
}
