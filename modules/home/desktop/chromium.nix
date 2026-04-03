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
}
