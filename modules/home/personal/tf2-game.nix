{
  config,
  pkgs,
  tf2Nix,
  ...
}:

let
  tf2pkgs = tf2Nix.legacyPackages.${pkgs.system};

  myTf2Config = tf2pkgs.mergeTf2Configs (
    with tf2pkgs;
    [
      mastercomfig.presets.low
      mastercomfig.addons.flat-mouse
      mastercomfig.addons.no-tutorial
      mastercomfig.addons.null-canceling-movement

      improved-crosshairs

    ]
  );

  # flatpak dir for tf2 relative to home
  tfDirRel = ".var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Team Fortress 2/tf";
in
{
  home.file.${tfDirRel} = {
    source = myTf2Config;
    recursive = true;
  };
}
