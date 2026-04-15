{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "framework";
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";
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

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [
      "10.30.0.7"
      "1.1.1.1"
    ];
  };

  environment.etc."ssl/openssl.cnf".text = ''
    openssl_conf = default_conf

    [default_conf]
    ssl_conf = ssl_sect

    [ssl_sect]
    system_default = system_default_sect

    [system_default_sect]
    MinProtocol = TLSv1
    CipherString = DEFAULT:@SECLEVEL=1
  ''; # fix macquarie onenet

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

}
