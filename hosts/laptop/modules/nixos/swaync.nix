{ lib, config, pkgs, ... }:


{
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
              "command"= "  ";
            }
            {
              "label" = "󰤄";
              "command" = "systemctl suspend";
            }
            {
              "label" = "󰖩";
              "command" = "$HOME/.local/bin/shved/rofi-menus/wifi-menu.sh";
            }
            {
              "label" = "󰂯";
              "command" = "blueman-manager";
            }
          ];
        };
      };
    };
  };
  # CSS Style settings
  Style = ''
  * {
      font-family: "0xProto";
      font-weight: bold;
      font-size: 25px
    }
    
    .control-center .notification-row:focus,
    .control-center .notification-row:hover {
        opacity: 1;
        background: ${background-900}
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
        background: ${background-700};
        padding: 7px;
        border-radius: 0px;
        border: 2px solid ${primary-400};
        margin: 0;
    }
    
    .close-button {
        background: ${primary-300};
        color: ${text-950};
        text-shadow: none;
        padding: 0;
        border-radius: 0px;
        margin-top: 5px;
        margin-right: 5px;
    }
    
    .close-button:hover {
        box-shadow: none;
        background: ${accent-400};
        transition: all .15s ease-in-out;
        border: none
    }
    
    .notification-action {
        color: ${text-200};
        border: 2px solid ${accent-400};
        border-top: none;
        border-radius: 0px;
        background: ${background-800};
    }
    
    .notification-default-action:hover,
    .notification-action:hover {
        color: ${text-200};
        background: ${background-900};
    }
    
    .summary {
      padding-top: 7px;
        font-size: 13px;
        color: ${text-200};
    }
    
    .time {
        font-size: 11px;
        background: ${text-400};
        margin-right: 24px
    }
    
    .body {
        font-size: 12px;
        color: ${text-200};
    }
    
    .control-center {
        background: ${background-950};
        border: 2px solid #85796f;
        border-radius: 0px;
    }
    
    .control-center-list {
        background: transparent
    }
    
    .control-center-list-placeholder {
        opacity: .5
    }
    
    .floating-notifications {
        background: transparent
    }
    
    .blank-window {
        background: alpha(black, 0.1)
    }
    
    .widget-title {
        color: ${text-100};
        background: ${background-950};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        font-size: 3rem;
        border-radius: 5px;
    }
    
    .widget-title>button {
        font-size: 1rem;
        color: ${text-100};
        text-shadow: none;
        background: ${background-800};
        box-shadow: none;
        border-radius: 5px;
    }
    
    .widget-title>button:hover {
        background: ${primary-400};
        color: ${background-400};
    }
    
    .widget-dnd {
        background: ${background-950};
        padding: 5px 10px;
        margin: 5px 10px 10px 10px;
        border-radius: 5px;
        font-size: large;
        color: ${text-100};
    }
    
    .widget-dnd>switch {
        border-radius: 4px;
        background: ${accent-400};
    }
    
    .widget-dnd>switch:checked {
        background: ${primary-400};
        border: 1px solid ${primary-400};
    }
    
    .widget-dnd>switch slider {
        background: ${background-800};
        border-radius: 5px
    }
    
    .widget-dnd>switch:checked slider {
        background: ${background-800};
        border-radius: 5px
    }
    
    .widget-label {
        margin: 10px 10px 5px 10px;
    }
    
    .widget-label>label {
        font-size: 1rem;
        color: ${text-100};
    }
    
    .widget-mpris {
        color: ${text-100};
        background: ${background-950};
        padding: 5px 10px 0px 0px;
        margin: 5px 10px 5px 10px;
        border-radius: 0px;
    }
    
    .widget-mpris > box > button {
        border-radius: 5px;
    }
    
    .widget-mpris-player {
        padding: 5px 10px;
        margin: 10px
    }
    
    .widget-mpris-title {
        font-weight: 700;
        font-size: 1.25rem
    }
    
    .widget-mpris-subtitle {
        font-size: 1.1rem
    }
    
    .widget-buttons-grid {
        font-size: 25px;
        padding: 5px;
        margin: 5px 10px 10px 10px;
        border-radius: 5px;
        background: ${background-950};
    }
    
    .widget-buttons-grid>flowbox>flowboxchild>button {
        margin: 3px;
        background: ${background-800};
        border-radius: 5px;
        color: ${text-100}
    }
    
    .widget-buttons-grid>flowbox>flowboxchild>button:hover {
        background: ${primary-400}
        color: ${background-800};
    }
    
    .widget-menubar>box>.menu-button-bar>button {
        border: none;
        background: transparent
    }
    
    .topbar-buttons>button {
        border: none;
        background: transparent
    }
  ''
}
