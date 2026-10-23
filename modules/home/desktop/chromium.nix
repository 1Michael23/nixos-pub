{
  config,
  pkgs,
  ...
}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--enable-features=VaapiVideoDecoder"
      "--disable-features=UseChromeOSDirectVideoDecoder"
    ];
  };

  xdg.desktopEntries.chromium-browser = {
    name = "Chromium";
    genericName = "Web Browser";
    exec = "${config.programs.chromium.finalPackage}/bin/chromium %U";
    icon = "chromium";
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
