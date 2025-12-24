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

  ];

  imports = [
    ../../modules/home/nixos/chromium.nix
    ../../modules/home/nixos/syncthing.nix

    ../../modules/home/common/tf2-game.nix

    ../../roles/home/development.nix
    ../../roles/home/pentesting.nix
    ../../roles/home/sway-home.nix

  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      pictures = "$HOME/pictures";
    };
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "chromium.desktop" ];
    };
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
