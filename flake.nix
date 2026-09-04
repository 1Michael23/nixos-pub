{
  description = "Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vibelock.url = "path:/home/michael/dev/vibelock";

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
    in
    {
      nixosConfigurations.framework = mkHost {
        hostname = "framework";
        system = "x86_64-linux";
      };

      nixosConfigurations.proxmox = mkHost {
        hostname = "proxmox";
        system = "x86_64-linux";
      };

      darwinConfigurations.mbp = mkDarwinHost {
        hostname = "mbp";
      };
    };
}
