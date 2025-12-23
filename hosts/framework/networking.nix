{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "fw";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    networkmanager.wifi.macAddress = "stable-ssid";
    firewall = {
      enable = true;
      checkReversePath = "loose"; # tailscale exit node patch
      allowedTCPPorts = [
        22000
        8384
        22
      ]; # 22000 8384 syncthing 22 ssh
      allowedUDPPorts = [
        22000
        21027
      ]; # 21027 syncthing
    };
  };

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

}
