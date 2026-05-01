{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-default-timeout = 10000;
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
    };

    style = ''
      .notification {
        background: rgba(43, 48, 59, 0.96);
        border-radius: 8px;
        margin: 6px 12px;
      }

      .notification-content {
        background: transparent;
      }

      .control-center {
        background: rgba(43, 48, 59, 0.96);
        border-radius: 8px;
      }

      .widget-title {
        background: transparent;
      }

      .widget-dnd {
        background: transparent;
      }
    '';
  };
}
