{
  config,
  pkgs,
  lib,
  inputs,
  isLinux ? false,
  isDarwin ? false,
  ...
}:

{
  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = "25.05";
  };

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/proxmox.yaml;
  };

  home.packages = with pkgs; [
    btop
    fastfetch
    ripgrep
    fd
    tree
    jq
    tlrc
    gdu
    sops
    age
  ];

  imports = [
    ../../modules/home/shell/fish.nix
    ../../modules/home/shell/git.nix
    ../../modules/home/shell/ssh.nix
    ../../modules/home/editors/neovim.nix
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = true;
      update_ms = 500;
    };
  };

  programs.bat.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_AU.UTF-8";
    NH_FLAKE = "$HOME/dev/nixos-pub";
  };
}
