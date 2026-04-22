{
  config,
  lib,
  pkgs,
  ...
}:

{
  xdg.configFile."aerospace/aerospace.toml".text = ''
    start-at-login = true

    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true
    accordion-padding = 30
    default-root-container-layout = 'tiles'
    default-root-container-orientation = 'auto'

    [gaps]
    inner.horizontal = 5
    inner.vertical   = 5
    outer.left       = 5
    outer.right      = 5
    outer.top        = 5
    outer.bottom     = 5


    [mode.main.binding]
    alt-enter       = "exec-and-forget open -a Terminal"
    alt-shift-q     = "close"
    alt-shift-c     = "reload-config"
    alt-shift-space = "layout floating tiling"
    alt-shift-f     = "fullscreen"

    alt-left  = "focus left"
    alt-down  = "focus down"
    alt-up    = "focus up"
    alt-right = "focus right"

    alt-shift-left  = "move left"
    alt-shift-down  = "move down"
    alt-shift-up    = "move up"
    alt-shift-right = "move right"

    alt-shift-period = "move-workspace-to-monitor next"
    alt-shift-comma  = "move-workspace-to-monitor prev"

    alt-1 = "workspace 1"
    alt-2 = "workspace 2"
    alt-3 = "workspace 3"
    alt-4 = "workspace 4"
    alt-5 = "workspace 5"
    alt-6 = "workspace 6"
    alt-7 = "workspace 7"
    alt-8 = "workspace 8"
    alt-9 = "workspace 9"
    alt-0 = "workspace 10"

    alt-shift-1 = "move-node-to-workspace 1"
    alt-shift-2 = "move-node-to-workspace 2"
    alt-shift-3 = "move-node-to-workspace 3"
    alt-shift-4 = "move-node-to-workspace 4"
    alt-shift-5 = "move-node-to-workspace 5"
    alt-shift-6 = "move-node-to-workspace 6"
    alt-shift-7 = "move-node-to-workspace 7"
    alt-shift-8 = "move-node-to-workspace 8"
    alt-shift-9 = "move-node-to-workspace 9"
    alt-shift-0 = "move-node-to-workspace 10"

    alt-r = "mode resize"

    [mode.resize.binding]
    left   = "resize width -50"
    right  = "resize width +50"
    up     = "resize height -50"
    down   = "resize height +50"
    enter  = "mode main"
    esc    = "mode main"
  '';
}
