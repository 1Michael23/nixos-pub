{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf pkgs.stdenv.isLinux {
  xdg.mimeApps.defaultApplications = {
    "image/x-sony-arw" = [ "photos.ansel.App.desktop" ];
    "image/x-adobe-dng" = [ "photos.ansel.App.desktop" ];
    "image/x-canon-cr2" = [ "photos.ansel.App.desktop" ];
    "image/x-canon-cr3" = [ "photos.ansel.App.desktop" ];
    "image/x-nikon-nef" = [ "photos.ansel.App.desktop" ];
    "image/tiff" = [ "photos.ansel.App.desktop" ];
  };

  xdg.configFile."ansel/anselrc".text = ''
    plugins/lighttable/thumbnail_hq=TRUE
    plugins/darkroom/clipping/show_focus_peaking=TRUE
    write_sidecar_files=after edit
    ui_last/import_last_directory=${config.home.homeDirectory}/Pictures
  '';
}
