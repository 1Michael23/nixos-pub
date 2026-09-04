{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.vesktop = {
    enable = true;
    settings = {
      customTitleBar = true;
      enableSplashScreen = true;
      splashTheming = true;
    };
    vencord.settings.plugins = {
      MessageLogger = {
        enabled = true;
        deleteStyle = "text";
        logDeletes = true;
        logEdits = true;
        inlineEdits = true;
        ignoreSelf = true;
        ignoreBots = false;
        collapseDeleted = false;
      };
      SpotifyCrack = {
        enabled = true;
        noSpotifyAutoPause = true;
        keepSpotifyActivityOnIdle = false;
      };
      ImageZoom = {
        enabled = true;
        saveZoomValues = true;
        invertScroll = true;
        nearestNeighbour = false;
        square = false;
        zoom = 2;
        size = 100;
        zoomSpeed = 0.5;
      };
      RelationshipNotifier = {
        enabled = true;
        notices = false;
        offlineRemovals = true;
        friends = true;
        friendRequestCancels = true;
        servers = true;
        groups = true;
      };
      PermissionsViewer = {
        enabled = true;
        permissionsSortOrder = "HighestRole";
      };
    };
  };
}
