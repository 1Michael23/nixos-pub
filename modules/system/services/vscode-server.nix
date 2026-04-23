{ inputs, ... }:

{
  imports = [ inputs.vscode-server.nixosModules.default ];

  services.vscode-server = {
    enable = true;
    enableFHS = true; # needed for some extensions (pylance, rust-analyzer binaries, etc.)
  };
}
