{
  config,
  pkgs,
  lib,
  inputs,
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
    ++ lib.optionals pkgs.stdenv.isLinux [
      gcr
      onlyoffice-desktopeditors
      moonlight-qt
      openssh
      jq
      freecad
      orca-slicer

    ];

  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ../../roles/home/development.nix
    ../../modules/home/desktop/xdg.nix
    ../../modules/home/desktop/chromium.nix
    ../../modules/home/services/syncthing.nix
    ../../modules/home/personal/tf2-game.nix
    ../../roles/home/pentesting.nix
    ../../roles/home/desktop-sway.nix
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
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    TERMINAL = "alacritty";
    BROWSER = "chromium";
  };
}
