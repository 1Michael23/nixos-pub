{ inputs, lib, ... }:

{
  imports = [ inputs.vscode-server.nixosModules.default ];

  services.vscode-server = {
    enable = true;
    enableFHS = true;
    installPath = lib.mkForce [
      "$HOME/.vscodium-server"
      "$HOME/.vscode-server"
    ];
  };
}
