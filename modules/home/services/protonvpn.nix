{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = [ pkgs.proton-vpn ];

    systemd.user.services.protonvpn = {
      Unit = {
        Description = "Proton VPN";
        After = [
          "graphical-session.target"
          "noctalia.service"
        ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.proton-vpn}/bin/protonvpn-app --start-minimized";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
