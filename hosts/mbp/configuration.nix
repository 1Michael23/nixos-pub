{ config, pkgs, ... }:

{
  system.stateVersion = 4;
  system.primaryUser = "michael";
  nixpkgs.config.allowUnfree = true;
  environment.shells = [ pkgs.fish ];
  users.users.michael = {
    name = "michael";
    home = "/Users/michael";
    shell = pkgs.fish;
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  system.defaults = {
    dock = {
      autohide = true;
      mineffect = "scale";
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      _FXSortFoldersFirst = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file://${builtins.getEnv "HOME"}/";
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [

  ];

  ids.gids.nixbld = 350;
}
