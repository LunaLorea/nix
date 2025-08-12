{
  lib,
  config,
  pkgs,
  colors,
  ...
}: let
  colors-background = "#060A13";
  colors-accent = "#529699";
  colors-accent-dark = "#4B7BA6";
  colors-waybar-text = "#efefef";
  text-50 = "#f2edf8";
  text-100 = "#e5daf1";
  text-200 = "#cbb6e2";
  text-300 = "#b091d4";
  text-400 = "#966cc6";
  text-500 = "#7c47b8";
  text-600 = "#633993";
  text-700 = "#4a2b6e";
  text-800 = "#321d49";
  text-900 = "#190e25";
  text-950 = "#0c0712";
  background-50 = "#f2ebf9";
  background-100 = "#e6d7f4";
  background-200 = "#ccafe9";
  background-300 = "#b288dd";
  background-400 = "#9960d2";
  background-500 = "#7f38c7";
  background-600 = "#662d9f";
  primary-50 = "#f2eafa";
  primary-100 = "#e5d6f5";
  primary-200 = "#cbacec";
  primary-300 = "#b183e2";
  primary-400 = "#975ad8";
  primary-500 = "#7d30cf";
  primary-600 = "#6427a5";
  primary-700 = "#4b1d7c";
  primary-800 = "#321353";
  primary-900 = "#190a29";
  primary-950 = "#0c0515";
  secondary-50 = "#f2e9fb";
  secondary-100 = "#e5d4f7";
  secondary-200 = "#cba9ef";
  secondary-300 = "#b17ee7";
  secondary-400 = "#9753df";
  secondary-500 = "#7d28d7";
  secondary-600 = "#6420ac";
  secondary-700 = "#4b1881";
  secondary-800 = "#321056";
  secondary-900 = "#19082b";
  secondary-950 = "#0c0416";
  accent-50 = "#f2e8fc";
  accent-100 = "#e5d2f9";
  accent-200 = "#cba5f3";
  accent-300 = "#b178ed";
  accent-400 = "#964ae8";
  accent-500 = "#7c1de2";
  accent-600 = "#6317b5";
  accent-700 = "#4b1287";
  accent-800 = "#320c5a";
  accent-900 = "#19062d";
  accent-950 = "#0c0317";
  modifier = config.wayland.windowManager.sway.config.modifier;
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
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 3;
      timeout-low = 2;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 500;
      control-center-height = 1025;
      notification-window-width = 440;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
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
              "command" = "  ";
            }
            {
              "label" = "󰤄";
              "command" = "systemctl suspend";
            }
            {
              "label" = "";
              "command" = "sway logout";
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
        font-size: 25px
      }


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
          background: ${colors.surface0};
          padding: 7px;
          border-radius: 0px;
          border: 2px solid ${colors.crust};
          margin: 0;
      }

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
          background: transparent;
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
    '';
  };
}
