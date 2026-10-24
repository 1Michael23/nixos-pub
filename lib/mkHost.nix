{
  nixpkgs,
  home-manager,
  sops-nix,
  nix-index-database,
  inputs,
}:

{
  hostname,
  system,
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs hostname;
  };

  modules = [
    ../hosts/${hostname}/default.nix
    ../modules/system/mcp-nixos.nix
    ../roles/system/base.nix
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          isLinux = true;
          isDarwin = false;
        };
        sharedModules = [
          sops-nix.homeManagerModules.sops
          nix-index-database.homeModules.default
        ];
      };
    }
  ];
}
