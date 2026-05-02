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
}:

darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs hostname;
  };

  modules = [
    ../hosts/${hostname}/configuration.nix
    sops-nix.darwinModules.sops

    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = extraSpecialArgs // {
          isLinux = false;
          isDarwin = true;
        };

        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.nix-index-database.homeModules.default

        ];
        users = builtins.mapAttrs (_name: import) users;
      };
    }
  ]
  ++ modules;
}
