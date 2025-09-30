{
  lib,
  config,
  pkgs,
  colors,
  ...
}: let
in {
  services.swaync = {
    enable = true;
    # Settings
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-2fa-action = true;
      notification-inline-replies = true;
      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 3;
      timeout-low = 2;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 1025;
      notification-window-width = 440;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = false;
      script-fail-notify = true;
      widgets = [
        "title"
        "dnd"
        "notifications"
        "mpris"
        "volume"
        "buttons-grid"
      ];
      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "󰆴";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notification Center";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
        volume = {
          label = "󰕾";
          show-per-app = true;
        };
        buttons-grid = {
          actions = [
            {
              "label" = "󰐥";
              "command" = "systemctl poweroff";
            }
            {
              "label" = "󰜉";
              "command" = "systemctl reboot";
            }
            {
              "label" = "󰌾";
              "command" = "lock";
            }
            {
              "label" = "󰤄";
              "command" = "systemctl suspend";
            }
            {
              "label" = "";
              "command" = "loginctl terminate-user $USER";
            }
          ];
        };
      };
    };
    # CSS Style settings
    style = ''
        * {
          font-family: "0xProto";
          font-weight: bold;
          font-size: 1rem;
          border: none;
          box-shadow: none;
          text-shadow: none;
          color: white;
        }

      .body {
        padding-right: 5px;
        font-size: 0.8rem;
      }

        /*
        .notification-row {
            outline: none;
            margin: 20px;
            padding: 0;
        }

        .notification {
            background: transparent;
            margin: 0px;
        }

        .notification-content {
            background: none;
            padding: 7px;
            border: none;
            margin: 0;
        }

        \\
        .close-button {
            text-shadow: none;
            padding: 0;
            border-radius: 0px;
            margin-top: 5px;
            margin-right: 5px;
        }

        .close-button:hover {
            box-shadow: none;
            transition: all .15s ease-in-out;
            border: none
        }

        .notification-action {
            border-top: none;
            border-radius: 0px;
            background: ${colors.surface0};
        }

        .notification-default-action:hover,
        .notification-action:hover {
        }

        .summary {
          padding-top: 7px;
            font-size: 13px;
            color: ${colors.subtext0};
        }

        .time {
            font-size: 11px;
            margin-right: 24px;
        }

        .body {
            font-size: 12px;
            background: ${colors.base};
            color: ${colors.text};
            opacity: 0.7;
        }

        .control-center {
            border: 0;
            border-radius: 0px;
        }

        .control-center-list {
            background: transparent;
        }

        .control-center-list-placeholder {
            opacity: .5;
        }

        .floating-notifications {
            dis
        }

        .blank-window {
            background: alpha(black, 0.1);
        }

        .widget-title {
            padding: 5px 10px;
            margin: 10px 10px 5px 10px;
            font-size: 3rem;
            border-radius: 5px;
        }

        .widget-title>button {
            font-size: 1rem;
            text-shadow: none;
            background: ${colors.surface0};
            box-shadow: none;
            border-radius: 5px;
        }

        .widget-title>button:hover {
            background: ${colors.red};
            color: ${colors.crust};
        }

        .widget-dnd {
            padding: 5px 10px;
            margin: 5px 10px 10px 10px;
            font-size: large;
        }

        .widget-dnd>switch {
            background: ${colors.red};
        }

        .widget-dnd>switch:checked {
            background: ${colors.green};
        }

        .widget-dnd>switch slider {
            background: ${colors.surface0};
            border: 0;
            border-radius: 5px;
        }

        .widget-dnd>switch:checked slider {
            background: ${colors.surface0};
            border-radius: 5px;
        }

        .widget-label {
            margin: 10px 10px 5px 10px;
        }

        .widget-label>label {
            font-size: 1rem;
        }

        .widget-mpris {
            padding: 5px 10px 0px 0px;
            margin: 5px 10px 5px 10px;
            border-radius: 0px;
        }

        .widget-mpris > box > button {
            border-radius: 5px;
        }

        .widget-mpris-player {
            padding: 5px 10px;
            margin: 10px;
        }

        .widget-mpris-title {
            font-weight: 700;
            font-size: 1.25rem;
        }

        .widget-mpris-subtitle {
            font-size: 1.1rem;
        }

        .widget-buttons-grid {
            font-size: 25px;
            padding: 5px;
            margin: 5px 10px 10px 10px;
            border-radius: 5px;
        }

        .widget-buttons-grid>flowbox>flowboxchild>button {
            margin: 3px;
            background: ${colors.surface0};
            border-radius: 5px;
        }

        .widget-buttons-grid>flowbox>flowboxchild>button:hover {
            background: ${colors.overlay0};
        }

        .widget-menubar>box>.menu-button-bar>button {
            border: none;
            background: transparent;
        }

        .topbar-buttons>button {
            border: none;
            background: transparent;
        }
        */
    '';
  };
}
