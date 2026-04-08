{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-zero-copy"
      "--enable-features=VaapiVideoDecoder"
      "--disable-features=UseChromeOSDirectVideoDecoder"
    ];

    #TODO declarative extensions
    #TODO declarative bookmarks

  };

  xdg.desktopEntries.chromium-browser = {
    name = "Chromium";
    genericName = "Web Browser";
    exec = "${pkgs.ungoogled-chromium}/bin/chromium %U";
    terminal = false;
    categories = [
      "Application"
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "text/html"
      "application/xhtml+xml"
    ];
  };
}
