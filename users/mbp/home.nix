{
  config,
  pkgs,
  lib,
  ...
}:

{
  home = {
    username = "mbp";
    homeDirectory = "/Users/mbp";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [

  ];

  imports = [
    ../../roles/home/development.nix
  ];

}
