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
        sponsorblock
        violentmonkey
        darkreader
        consent-o-matic
        dearrow
      ];

      settings = {
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "ui.systemUsesDarkTheme" = 1;

        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "gfx.webrender.all" = true;
        "widget.dmabuf.force-enabled" = false;
        "media.av1.enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;

        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        "browser.download.useDownloadDir" = true;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.aboutConfig.showWarning" = false;
        "apz.gtk.kinetic_scroll.enabled" = true;

        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";
        "webgl.disabled" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "layout.css.prefers-color-scheme.content-override" = 0;
      };
    };
  };
}
