{ pkgs, ... }:
{
  home.packages = [ pkgs.localsend ];

  # Run hidden at login so incoming transfers work without a window; a second
  # launch from the launcher hands off to this instance and shows the window.
  systemd.user.services.localsend = {
    Unit = {
      Description = "LocalSend";
      After = [
        "graphical-session.target"
        "noctalia.service"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.localsend}/bin/localsend --hidden";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
