# lib/mkDarwinHost.nix
{
  darwin,
  home-manager,
  sops-nix,
  inputs,
}:

{
  hostname,
  system ? "aarch64-darwin",
  users ? { },
  modules ? [ ],
  extraSpecialArgs ? { },
  stateVersion ? 4,
}:

darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs hostname;
  };

  modules = [
    ../hosts/${hostname}/configuration.nix

    home-manager.darwinModules.home-manager
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
  ++ modules;
}
