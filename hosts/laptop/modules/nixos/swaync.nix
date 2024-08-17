{ lib, config, pkgs, ... }:


{
  services.swaync = {
    enable = true;
    style = ./swaync.css;
    settings = {
      positionX = "left";
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
          button-text = "󰆴 Clear All";
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
              "command"= "$HOME/.config/hypr/scripts/lock-session.sh";
            }
            {
              "label" = "󰍃";
              "command" = "hyprctl dispatch exit";
            }
            {
              "label" = "󰤄";
              "command" = "systemctl suspend";
            }
            {
              "label" = "󰕾";
              "command" = "swayosd-client --output-volume mute-toggle";
            }
            {
              "label" = "󰍬";
              "command" = "swayosd-client --input-volume mute-toggle";
            }
            {
              "label" = "󰖩";
              "command" = "$HOME/.local/bin/shved/rofi-menus/wifi-menu.sh";
            }
            {
              "label" = "󰂯";
              "command" = "blueman-manager";
            }
            {
              "label" = "";
              "command" = "os";
            }
          ];
        };
      };
    };
  };
}
