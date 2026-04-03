{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.trayscale ];

    systemd.user.services.trayscale = {
      Unit = {
        Description = "Trayscale - Tailscale tray";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.trayscale}/bin/trayscale";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
