{
  darwin,
  home-manager,
  sops-nix,
  nix-index-database,
  inputs,
}:

{
  hostname,
  system ? "aarch64-darwin",
}:

darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs;
  };

  modules = [
    { nixpkgs.config.allowUnfree = true; }
    ../hosts/${hostname}/configuration.nix
    ../modules/system/mcp-nixos.nix
    sops-nix.darwinModules.sops
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          isLinux = false;
          isDarwin = true;
        };
        sharedModules = [
          sops-nix.homeManagerModules.sops
          nix-index-database.homeModules.default
        ];
      };
    }
  ];
}
