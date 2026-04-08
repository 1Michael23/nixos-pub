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
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/michael" else "/home/michael";
    stateVersion = "25.05";
  };

  home.packages =
    with pkgs;
    [

    ]
    ++ lib.optionals isLinux [
      gcr
      onlyoffice-desktopeditors
      moonlight-qt
      openssh
      jq
      freecad
      orca-slicer
      discord

    ];

  imports = [
    ../../roles/home/development.nix

  ]
  ++ lib.optionals isDarwin [
    inputs.mac-app-util.homeManagerModules.default
  ]
  ++ lib.optionals isLinux [
    ../../modules/home/desktop/xdg.nix
    ../../modules/home/desktop/chromium.nix
    ../../modules/home/desktop/librewolf.nix
    ../../roles/home/pentesting.nix
    ../../roles/home/desktop-sway.nix
    #../../roles/home/desktop-gnome.nix
    ../../modules/home/personal/tf2-game.nix
    ../../modules/home/services/syncthing.nix
  ];

  # sops - Linux only (framework laptop)
  #sops = lib.mkIf pkgs.stdenv.isLinux {
  #  age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  #  defaultSopsFile = ../../secrets/framework.yaml;
  #  secrets."syncthing/device_id_mbp" = { };
  #  secrets."syncthing/device_id_fedora" = { };
  #};

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = true;
      proc_sorting = "cpu lazy";
      show_gpu = pkgs.stdenv.isLinux;
      update_ms = 500;
    };
  };

  programs.bat.enable = true;

  services.gnome-keyring = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_AU.UTF-8";
    NH_FLAKE = "$HOME/dev/nixos-pub";
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    TERMINAL = "alacritty";
    BROWSER = "chromium";

  };
}
