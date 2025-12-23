{ config, lib, pkgs, ... }:

{
    services.syncthing = {
        enable = true;              
        tray.enable = true; 

        overrideDevices = true;
        overrideFolders = true;

        settings = {
            guiAddress = "127.0.0.1:8384";
           
            devices = {
                "mbp" = { id = "3SQ2CR6-SXCFSBN-T7MFZWS-DKCULI2-GPS6BZT-JDFXWH4-MA6F33A-N7FTGQI"; };
                "fedora-max" = { id = "GSNSVZM-PLL5CR6-EKK42WA-VAKXPUW-JBPNZ6S-XPNLHRC-CL2OPPZ-SOOGYAG"; };
            };
       
            folders = {
                "dev" = {
                  id = "dev";
                  path = "${config.home.homeDirectory}/dev"; 
                  devices = [ "mbp" "fedora-max" ];
                };
                "uni" = {
                  id = "uni";
                  path = "${config.home.homeDirectory}/documents/uni"; 
                  devices = [ "mbp" "fedora-max" ];
                };
                "photos-picks" = {
                  id = "piiqn-2kljc";
                  path = "${config.home.homeDirectory}/pictures/picks"; 
                  devices = [ "mbp" "fedora-max" ];
                };
                "wallpapers" = {
                  id = "wallpapers";
                  path = "${config.home.homeDirectory}/pictures/wallpapers"; 
                  devices = [ "mbp" "fedora-max" ];
                };
                "Work" = {
                  id = "work";
                  path = "${config.home.homeDirectory}/doccuments/work"; 
                  devices = [ "mbp" "fedora-max" ];
                };
                "breaches" = {
                  id = "breaches";
                  path = "${config.home.homeDirectory}/doccuments/breaches"; 
                  devices = [ "fedora-max" ];
                };
                
            };
        };
    };
}