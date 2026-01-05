{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/http" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/https" = [ "re.sonny.Junction.desktop" ];

        "x-scheme-handler/file" = [ "re.sonny.Junction.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

      };

      associations.added = {
        "x-scheme-handler/http" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/https" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/file" = [ "re.sonny.Junction.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

      };
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${home}/Desktop";
    documents = "${home}/Documents";
    download = "${home}/Downloads";
    music = "${home}/Music";
    pictures = "${home}/Pictures";
    publicShare = "${home}/Public";
    templates = "${home}/Templates";
    videos = "${home}/Videos";
  };

  # Nautilus sidebar “Places” are driven by GTK bookmarks
  home.file.".config/gtk-3.0/bookmarks".text = ''
    file://${home}/Downloads Downloads
    file://${home}/Documents Documents
    file://${home}/Pictures Pictures
    file://${home}/Videos Videos
    file://${home}/Music Music
    file://${home} Home
  '';

  # If you use apps that read GTK4’s file chooser/bookmarks too, keep them in sync:
  home.file.".config/gtk-4.0/bookmarks".text = ''
    file://${home}/Downloads Downloads
    file://${home}/Documents Documents
    file://${home}/Pictures Pictures
    file://${home}/Videos Videos
    file://${home}/Music Music
    file://${home} Home
  '';
}
