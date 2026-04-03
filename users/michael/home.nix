{
  config,
  pkgs,
  lib,
  ...
}:

{
  home = {
    username = "michael";
    homeDirectory = "/Users/michael";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    moonlight-qt
    onlyoffice-desktopeditors

    openssh
    jq
    htop
  ];

  imports = [
    ../../roles/home/development.nix
  ];

  # macOS-specific session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_AU.UTF-8";
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = true;
      proc_sorting = "cpu lazy";
      update_ms = 500;
    };
  };

  programs.bat.enable = true;
}
