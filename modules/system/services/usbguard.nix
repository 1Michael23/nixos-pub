# TODO wire up usbguard prompt with fuzzel
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.usbguard = {
    enable = true;

    presentDevicePolicy = "apply-policy";
    presentControllerPolicy = "keep";
    implicitPolicyTarget = "block";
    insertedDevicePolicy = "apply-policy";

    IPCAllowedUsers = [ "michael" ];
    IPCAllowedGroups = [ "wheel" ];

    restoreControllerDeviceState = false;

    rules = ''
      allow id 1d6b:0002 serial "0000:c1:00.3" name "xHCI Host Controller" hash "p9XdYtshh7dWZvylwnT2mODxf1un62IZMB3s1EZjqbs=" parent-hash "mJdJHWCEQ2iPsjBBi4Yl9tmTcJQmdVpgafPRzXlRV9U=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:c1:00.3" name "xHCI Host Controller" hash "GhaKQL/HuMTEtGBGLV9jNs62nKoScYKr1LeONmY0tEs=" parent-hash "mJdJHWCEQ2iPsjBBi4Yl9tmTcJQmdVpgafPRzXlRV9U=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:c1:00.4" name "xHCI Host Controller" hash "Hc8P2OygD2+wF1fFNwvlpeIVyRbf+OODwtf4qnle/Y8=" parent-hash "nZZ3nkqoEMlYNSKO2SeX1nR/LwLPE6GTayrbRu3D1pU=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:c1:00.4" name "xHCI Host Controller" hash "G4i5biVc/Q4tDN6CqmBKM1uVPQW5pvKMqsQtNPei2TE=" parent-hash "nZZ3nkqoEMlYNSKO2SeX1nR/LwLPE6GTayrbRu3D1pU=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:c3:00.3" name "xHCI Host Controller" hash "oSRBqitQDOgWuBAedOGgTHiwDU//ZY3Hg/EJsQfNmvM=" parent-hash "MoJ8FZSZJd/VDdGtr28IOLmQPH6G5m24G50ldOqGdfo=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:c3:00.3" name "xHCI Host Controller" hash "XGK2oujO9TztgFfBqLjpYBytjvhjDwwSZriJSCdhi8Q=" parent-hash "MoJ8FZSZJd/VDdGtr28IOLmQPH6G5m24G50ldOqGdfo=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0002 serial "0000:c3:00.4" name "xHCI Host Controller" hash "ytflbcUR58vOaTlsVdDp+prbapFyL+b4z2vdOAgegjM=" parent-hash "0Zqwj+n2tT57N8mqsEeUWN4fJNpMYtDdL3cN6GSctzI=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:c3:00.4" name "xHCI Host Controller" hash "Zlfas9XDavZIIav5URjbmR1k1M9e1RvGgGcXyk9KCJ8=" parent-hash "0Zqwj+n2tT57N8mqsEeUWN4fJNpMYtDdL3cN6GSctzI=" with-interface 09:00:00 with-connect-type ""
      allow id 32ac:0002 serial "11AD1D00A49C4014271C0B00" name "HDMI Expansion Card" hash "VmLn9/JTP6CHxhdcUamIII+0O61Nd0gJJpevlnhAvts=" parent-hash "p9XdYtshh7dWZvylwnT2mODxf1un62IZMB3s1EZjqbs=" with-interface { 11:00:00 03:00:00 } with-connect-type "hotplug"
      allow id 27c6:609c serial "UID036501B2_XXXX_MOC_B0" name "Goodix Fingerprint USB Device" hash "PyqNNgiiRUF/WMGGDT1O33J5MAuIlp83fzKLC+0/BgA=" parent-hash "p9XdYtshh7dWZvylwnT2mODxf1un62IZMB3s1EZjqbs=" with-interface ff:00:00 with-connect-type "hardwired"
      allow id 0e8d:e616 serial "000000000" name "Wireless_Device" hash "erna9raFW4Dl/v6M4pInxogL0kJv1XNVxBTVuoNFhBA=" parent-hash "p9XdYtshh7dWZvylwnT2mODxf1un62IZMB3s1EZjqbs=" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired"
      allow id 17ef:a392 serial "" name "USB2.0 Hub" hash "PypkiVGdFiVdmb9QWRg4TCkoJ+Jp1TcXtU1x8GhS/zA=" parent-hash "ytflbcUR58vOaTlsVdDp+prbapFyL+b4z2vdOAgegjM=" via-port "7-1" with-interface { 09:00:01 09:00:02 } with-connect-type "hotplug"
      allow id 17ef:a391 serial "" name "USB3.1 Hub" hash "bSPFJDY6VJB1/TLktY1SKMnyq8yM+xoYRZzUNYGBJ1E=" parent-hash "Zlfas9XDavZIIav5URjbmR1k1M9e1RvGgGcXyk9KCJ8=" via-port "8-1" with-interface 09:00:00 with-connect-type "hotplug"
      allow id 0d8c:0089 serial "201805" name "ATGM1-USB" hash "tng4pAFyMqx5m744cszNY35tcXz3akcAEtNW6quryUo=" parent-hash "PypkiVGdFiVdmb9QWRg4TCkoJ+Jp1TcXtU1x8GhS/zA=" with-interface { 01:01:00 01:02:00 01:02:00 03:00:00 } with-connect-type "unknown"
      allow id 17ef:a394 serial "" name "USB2.0 Hub" hash "lP1MiStgC6H3DzgyitbjfOfTvjInIQBn7OsXDDjTAd4=" parent-hash "PypkiVGdFiVdmb9QWRg4TCkoJ+Jp1TcXtU1x8GhS/zA=" via-port "7-1.3" with-interface { 09:00:01 09:00:02 } with-connect-type "unknown"
      allow id 17ef:a387 serial "301000001" name "USB-C Dock Ethernet" hash "PdxMA1X8xVL5G8GygzKiVaxEGe/E68egOcp4ci8l6/4=" parent-hash "bSPFJDY6VJB1/TLktY1SKMnyq8yM+xoYRZzUNYGBJ1E=" with-interface { ff:ff:00 02:06:00 0a:00:00 0a:00:00 } with-connect-type "unknown"
      allow id 17ef:a393 serial "" name "USB3.1 Hub" hash "69Y339Uk+TVaNGT//cRD1MmHwOhl6SYF5sTmIAiG+MU=" parent-hash "bSPFJDY6VJB1/TLktY1SKMnyq8yM+xoYRZzUNYGBJ1E=" via-port "8-1.3" with-interface 09:00:00 with-connect-type "unknown"
      allow id 3434:d030 serial "" name "Keychron Link " hash "gfm9dUg3k4ERginO0CR4zhvckjZ/kZ+to/WtGxgHdZ8=" parent-hash "lP1MiStgC6H3DzgyitbjfOfTvjInIQBn7OsXDDjTAd4=" via-port "7-1.3.2" with-interface { 03:01:02 03:01:01 03:01:01 03:00:00 } with-connect-type "unknown"
      allow id 17ef:a395 serial "" name "USB2.0 Hub" hash "zZYYfrUbupQM8DZXGy8czWNditt0hnauSHtIeYx1TZk=" parent-hash "lP1MiStgC6H3DzgyitbjfOfTvjInIQBn7OsXDDjTAd4=" via-port "7-1.3.3" with-interface 09:00:00 with-connect-type "unknown"
      allow id 3434:0b10 serial "" name "Keychron Q1 HE" hash "fO1y8+5HyPOSiobQ7PzvXZBAN0bflJQWa5OatUcM88E=" parent-hash "lP1MiStgC6H3DzgyitbjfOfTvjInIQBn7OsXDDjTAd4=" via-port "7-1.3.4" with-interface { 03:01:01 03:00:00 } with-connect-type "unknown"
      allow id 04b4:521a serial "" name "USB-I2C Bridge" hash "FW1i/NYxIgZbwwR1aoQhld2mwHcWIa8evtb9NDK2UyU=" parent-hash "zZYYfrUbupQM8DZXGy8czWNditt0hnauSHtIeYx1TZk=" via-port "7-1.3.3.1" with-interface { ff:03:00 ff:05:00 } with-connect-type "unknown"
      allow id 17ef:30d1 serial "000000000000" name "ThinkPad USB-C Dock Gen2 USB Audio" hash "HlVxQidTq+BJltIp/8wG3BpGG4rrfyLsp6uUWiDQWp0=" parent-hash "zZYYfrUbupQM8DZXGy8czWNditt0hnauSHtIeYx1TZk=" with-interface { 01:01:20 01:02:20 01:02:20 01:02:20 01:02:20 01:02:20 03:00:00 } with-connect-type "unknown"
      allow id 2b5a:0020 serial "22112036022592" name "Volt 1" hash "UwPt9+AtN/gu7VAytdu1nw7K6MoSMOaMDgQjRx3unyU=" parent-hash "zZYYfrUbupQM8DZXGy8czWNditt0hnauSHtIeYx1TZk=" with-interface { 01:01:20 01:02:20 01:02:20 01:02:20 01:02:20 01:02:20 01:02:20 01:01:00 01:03:00 fe:01:01 03:00:00 01:01:20 01:02:20 01:02:20 01:02:20 01:02:20 01:02:20 01:02:20 01:01:00 01:03:00 fe:01:01 03:00:00 } with-connect-type "unknown"
      allow id 046d:c547 serial "" name "USB Receiver" hash "gFx7kcPo3OnfDcPhrJk3PxeBiF1o6/JGeTevInhob4A=" parent-hash "zZYYfrUbupQM8DZXGy8czWNditt0hnauSHtIeYx1TZk=" via-port "7-1.3.3.4" with-interface { 03:01:02 03:01:01 03:00:00 } with-connect-type "unknown"
    '';
  };

  # Audit events to journald via auditd
  environment.etc."usbguard/usbguard-daemon.conf.d/10-audit.conf".text = ''
    AuditBackend=LinuxAudit
    AuditFilePath=/var/log/usbguard/usbguard-audit.log
  '';

  environment.systemPackages = with pkgs; [
    usbguard
    usbguard-notifier
    inputs.usbguard-fuzzel.packages.${pkgs.system}.default
  ];

}
