{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "framework";
  home.homeDirectory = "/home/framework";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [

    gcr
    openssh

    orca-slicer
    moonlight-qt

    freecad

    onlyoffice-desktopeditors

  ];

  imports = [
    ../../modules/home/desktop/xdg.nix
    ../../modules/home/desktop/chromium.nix
    ../../modules/home/services/syncthing.nix

    ../../modules/home/personal/tf2-game.nix

    ../../roles/home/development.nix
    ../../roles/home/pentesting.nix
    ../../roles/home/desktop-sway.nix

  ];

  sops = {
    # local age key
    age.keyFile = "/home/framework/.config/sops/age/keys.txt";

    defaultSopsFile = ../../secrets/framework.yaml;

    secrets."syncthing/device_id_mbp" = { };
    secrets."syncthing/device_id_fedora" = { };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = true;
      proc_sorting = "cpu lazy";
      show_gpu = true;
      update_ms = 500;
    };
  };

  programs.bat.enable = true;
  services.gnome-keyring.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "chromium";
    LANG = "en_AU.UTF-8";
  };
}
