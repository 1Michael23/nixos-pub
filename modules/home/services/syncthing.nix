{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.syncthing = {
    enable = true;
    tray.enable = true;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      guiAddress = "127.0.0.1:8384";

      devices = {
        "mbp" = {
          id = "W3MJCQD-7AGFDDW-WZK7E5A-SF3O4VS-EVHOJTO-OW6E65D-H2SKRKB-VN6QEQ3";
        };
        "fedora-max" = {
          id = "GSNSVZM-PLL5CR6-EKK42WA-VAKXPUW-JBPNZ6S-XPNLHRC-CL2OPPZ-SOOGYAG";
        };
      };

      folders = {
        "dev" = {
          id = "dev";
          path = "${config.home.homeDirectory}/dev";
          devices = [
            "mbp"
            "fedora-max"
          ];
        };
        "uni" = {
          id = "uni";
          path = "${config.home.homeDirectory}/Documents/uni";
          devices = [
            "mbp"
            "fedora-max"
          ];
        };
        "photos-picks" = {
          id = "piiqn-2kljc";
          path = "${config.home.homeDirectory}/Pictures/picks";
          devices = [
            "mbp"
            "fedora-max"
          ];
        };
        "wallpapers" = {
          id = "wallpapers";
          path = "${config.home.homeDirectory}/Pictures/wallpapers";
          devices = [
            "mbp"
            "fedora-max"
          ];
        };
        "breaches" = {
          id = "breaches";
          path = "${config.home.homeDirectory}/Documents/breaches";
          devices = [ "fedora-max" ];
        };

      };
    };
  };
}
