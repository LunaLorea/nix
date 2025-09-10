{
  lib,
  config,
  pkgs,
  colors,
  ...
}: let
  waybar-module-pomodoro = import ''${builtins.path {path = ../../custom-pkgs/waybar-module-pomodoro.nix;}}'' {inherit pkgs;};
in {
  home.packages = [waybar-module-pomodoro]; # Pomodoro module import
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      default = {
        layer = "top";
        position = "top";
        height = 39;
        margin-left = 8;
        margin-right = 8;
        margin-top = 8;
        margin-bottom = 0;
        output = [
          "*"
        ];

        modules-left = ["clock" "battery" "bluetooth"];
        modules-center = ["sway/workspaces"];
        modules-right = ["tray" "sway/language" "custom/pomodoro" "custom/notifications"];

        "sway/workspaces" = {
          on-click = "activate";
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "default" = "○";
            "focused" = "●";
          };
        };
        "network" = {
          format = "{ifname}";
          format-wifi = "{essid} ";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) \nip: {ipaddr}\nup: {bandwidthUpBits}\ndown: {bandwidthDownBits}";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };

        "bluetooth" = {
          on-click = "blueman-manager";
          format = " {status}";
          format-disabled = " disabled";
          format-off = " off";
          format-on = " -";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          format-connected = " {device_alias}";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };

        "mpris" = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          interval = 1;
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
          ignored-players = ["firefox"];
        };
        "clock" = {
          interval = 60;
          format = "{:%H:%M}";
          tooltip = false;
        };

        "sway/language" = {
          format = "{short}";
          on-click = "swaymsg input type:keyboard xkb_switch_layout next";
          tooltip = false;
        };
        "battery" = {
          interval = 30;
          format = "{capacity}%{icon}";
          format-icons = {
            "0" = "󰂎";
            "1" = "󱊡";
            "2" = "󱊢";
            "3" = "󱊣";
          };
          tooltip-format = "Usage: {power}W\n{timeTo}\n{cycles} cycles\n{health}";
          full-at = 98;
        };
        "custom/notifications" = {
          format = "";
          on-click = "swaync-client -t -sw";
          tooltip = false;
        };
        "custom/pomodoro" = {
          format = "{}";
          return-type = "json";
          exec = "waybar-module-pomodoro";
          on-click = "waybar-module-pomodoro toggle";
          on-click-right = "waybar-module-pomodoro reset";
        };
        "tray" = {
          icon-size = 21;
          spacing = 10;
          show-passive-items = true;
        };
      };
    };
    style = ''
      window {
        border: none;
        font-family: "0xProto";
        background-color: rgba(0, 0, 0, 0);
        color: ${colors.text};
        font-size: 25px;
      }
      window#waybar {
        background-color: alpha(${colors.base}, 0.8);
        border-radius: 7px;
      }
      .module {
        background-color: rgba(0, 0, 0, 0);
        padding-left: 20px;
        padding-right: 20px;
        margin-right: 5px;
        margin-left: 5px;
      }
      .tooltip {
        border-radius: 0px;
      }
      #workspaces button {
        padding: 0px 5px;
        font-size: 30px;
        color: #efefef;
      }

      #network {
        min-width: 160px;
      }
      #custom-notifications {
        margin-left: 0px;
        margin-right: 20px;
      }
      .work {
        background: ${colors.red};
        color: ${colors.crust};
      }
      .break {
        background: ${colors.green};
        color: ${colors.crust};
      }
      .pause {
        background: ${colors.yellow};
        color: ${colors.crust};
      }
    '';
  };
}
