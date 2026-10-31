{
  config,
  pkgs,
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
    jq
    gdu
  ];

  imports = [
    ../../modules/home/shell/fish.nix
    ../../modules/home/shell/git.nix
    ../../modules/home/shell/fastfetch.nix
    ../../roles/home/development.nix

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

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_AU.UTF-8";
    NH_FLAKE = "${config.home.homeDirectory}/dev/nixos-pub";
  };
}
