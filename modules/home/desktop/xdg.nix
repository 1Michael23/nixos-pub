{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{
  home = {
    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      gtk.enable = true;
    };

    file = {
      ".config/gtk-3.0/bookmarks".text = ''
        file://${home}/Downloads Downloads
        file://${home}/Documents Documents
        file://${home}/dev Dev
        file://${home}/Pictures Pictures
        file://${home}/Videos Videos
        file://${home}/Music Music
      '';

      ".config/gtk-4.0/bookmarks".text = ''
        file://${home}/Downloads Downloads
        file://${home}/Documents Documents
        file://${home}/dev Dev
        file://${home}/Pictures Pictures
        file://${home}/Videos Videos
        file://${home}/Music Music
      '';
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      size = 11;
      package = pkgs.dejavu_fonts;
    };
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/http" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/https" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/file" = [ "re.sonny.Junction.desktop" ];

        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

        "image/jpeg" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/gif" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/webp" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/svg+xml" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/avif" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/bmp" = [ "org.nomacs.ImageLounge.desktop" ];

        "image/x-sony-arw" = [ "re.sonny.Junction.desktop" ];

        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/mpeg" = [ "mpv.desktop" ];

        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "audio/x-matroska" = [ "mpv.desktop" ];

        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];

        "application/pdf" = [ "re.sonny.Junction.desktop" ];
        "application/msword" = [ "org.onlyoffice.desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
          "org.onlyoffice.desktopeditors.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
          "org.onlyoffice.desktopeditors.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
          "org.onlyoffice.desktopeditors.desktop"
        ];
        "application/vnd.oasis.opendocument.text" = [ "org.onlyoffice.desktopeditors.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet" = [ "org.onlyoffice.desktopeditors.desktop" ];
        "application/vnd.oasis.opendocument.presentation" = [ "org.onlyoffice.desktopeditors.desktop" ];
      };

      associations.added = {
        "x-scheme-handler/http" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/https" = [ "re.sonny.Junction.desktop" ];
        "x-scheme-handler/file" = [ "re.sonny.Junction.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "image/jpeg" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/gif" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/webp" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/svg+xml" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/avif" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/bmp" = [ "org.nomacs.ImageLounge.desktop" ];
        "image/x-sony-arw" = [ "re.sonny.Junction.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/mpeg" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "audio/x-matroska" = [ "mpv.desktop" ];
        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
        "application/pdf" = [ "re.sonny.Junction.desktop" ];
        "application/msword" = [ "org.onlyoffice.desktopeditors.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
          "org.onlyoffice.desktopeditors.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
          "org.onlyoffice.desktopeditors.desktop"
        ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
          "org.onlyoffice.desktopeditors.desktop"
        ];
        "application/vnd.oasis.opendocument.text" = [ "org.onlyoffice.desktopeditors.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet" = [ "org.onlyoffice.desktopeditors.desktop" ];
        "application/vnd.oasis.opendocument.presentation" = [ "org.onlyoffice.desktopeditors.desktop" ];
      };
    };
  };

  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
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
}
