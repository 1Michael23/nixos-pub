{
  config,
  pkgs,
  tf2Nix,
  ...
}:

let
  tf2pkgs = tf2Nix.legacyPackages.${pkgs.system};

  #tfDirRel = ".var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Team Fortress 2/tf";
  tfDirRel = ".local/share/Steam/steamapps/common/Team Fortress 2/tf";

  myTf2Config = tf2pkgs.mergeTf2Configs (
    with tf2pkgs;
    [
      mastercomfig.presets.medium-low
      mastercomfig.addons.flat-mouse
      mastercomfig.addons.no-tutorial
      mastercomfig.addons.null-canceling-movement

      improved-crosshairs
      huds.deerhud
    ]
  );

in
{
  home.file.${tfDirRel} = {
    source = myTf2Config;
    recursive = true;
  };
  home.file."${tfDirRel}/cfg/autoexec.cfg".text = ''
    cl_hud_playerclass_use_playermodel 1
  '';
}
