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
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/michael" else "/home/michael";
    stateVersion = "25.05";
  };

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = if isDarwin then ../../secrets/mbp.yaml else ../../secrets/framework.yaml;
  };

  home.packages =
    with pkgs;
    lib.optionals isLinux [
      onlyoffice-desktopeditors
      moonlight-qt
      openssh
      jq
      bitwarden-cli
      gcr_3 # gcr-prompter: provides org.gnome.keyring.SystemPrompter for gnome-keyring
    ];

  imports = [
    ../../roles/home/development.nix
    ../../roles/home/photography.nix
    ../../modules/home/shell/ssh.nix
    ../../modules/home/shell/gpg-agent.nix
    ../../modules/home/shell/fastfetch.nix

  ]
  ++ lib.optionals isDarwin [
    inputs.mac-app-util.homeManagerModules.default
    ../../modules/home/darwin/aerospace.nix
  ]
  ++ lib.optionals isLinux [
    ../../modules/home/desktop/xdg.nix
    ../../modules/home/desktop/chromium.nix
    ../../modules/home/desktop/librewolf.nix
    ../../roles/home/pentesting.nix
    ../../roles/home/desktop-niri.nix
    ../../modules/home/personal/tf2-game.nix
    ../../modules/home/services/syncthing.nix
  ];

  custom.pgp = {
    enable = true;
    defaultKey = "0xAABE0C32D79DFF9B";
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = true;
      proc_sorting = "cpu lazy";
      show_gpu = pkgs.stdenv.hostPlatform.isLinux;
      update_ms = 500;
    };
  };

  programs.bat.enable = true;

  services.gnome-keyring = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_AU.UTF-8";
    NH_FLAKE = "$HOME/dev/nixos-pub";
  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    TERMINAL = "alacritty";

  };

  home.sessionPath = lib.mkIf isLinux [ "${config.home.homeDirectory}/.local/bin" ];
}
