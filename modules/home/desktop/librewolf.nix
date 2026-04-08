{
  config,
  lib,
  pkgs,
  firefox-addons,
  ...
}:

{
  programs.librewolf = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      extensions.packages = with firefox-addons; [
        ublock-origin
        bitwarden
        privacy-badger
        clearurls
        decentraleyes
        terms-of-service-didnt-read
        sponsorblock
        return-youtube-dislikes
        violentmonkey
      ];

      settings = {

        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "ui.systemUsesDarkTheme" = 1;

        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;

        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        "browser.download.useDownloadDir" = true;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.aboutConfig.showWarning" = false;
        "full-screen-api.ignore-widgets" = true; # proper fullscreen in tiling WMs
        "apz.gtk.kinetic_scroll.enabled" = true; # smooth scrolling on touchpad

        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = false;
        "webgl.disabled" = false;
        "identity.fxa.enabled" = false;
        "privacy.clearOnShutdown.cookies" = false;

        "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = false;
        "layout.css.prefers-color-scheme.content-override" = 2;
      };
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
