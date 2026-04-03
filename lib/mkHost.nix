# lib/mkHost.nix
{
  nixpkgs,
  home-manager,
  sops-nix,
  inputs,
}:

{
  hostname,
  system,
  users ? { },
  modules ? [ ],
  extraSpecialArgs ? { },
  secureBoot ? false,
  stateVersion ? "25.05",
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  # specialArgs makes these available in every module's function args
  specialArgs = {
    inherit inputs hostname;
  };

  modules = [
    # host specific modules
    ../hosts/${hostname}/default.nix

    # modules every linux host gets
    ../roles/system/nixos-base.nix
    sops-nix.nixosModules.sops

    { system.stateVersion = stateVersion; }

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = extraSpecialArgs;
      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      home-manager.users = builtins.mapAttrs (name: homePath: import homePath) users;
    }
  ]
  ++ modules
  ++ nixpkgs.lib.optionals secureBoot [
    inputs.lanzaboote.nixosModules.lanzaboote
    {
      environment.systemPackages = [
        nixpkgs.legacyPackages.${system}.sbctl
      ];
      boot.loader.systemd-boot.enable = nixpkgs.lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    }
  ];
}
