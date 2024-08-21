{ lib, config, pkgs, ... }:
let
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
  background-700 = "#4c2277";
  background-800 = "#331650";
  background-900 = "#190b28";
  background-950 = "#0d0614";
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
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {

      default = {
        layer = "top";
        position = "top";
        height = 36;
        margin-left = 8;
        margin-right = 8;
        margin-top = 8;
        margin-bottom = 0;
        output = [
          "*"
        ];

        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "battery" "tray" "sway/language" "clock" "custom/notifications" ];

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
        "clock" = {
          interval = 60;
          format = "{:%H:%M}";
          tooltip = false;
        };
        "network" = {
          interval = 1;
          format-wifi = "{essid} ";
          format-ethernet = "Wired 󰈀";
          tooltip-format-wifi = "{ipaddr} ({signalStrength}%)";
          tooltip-format = "{ipaddr}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "󰤮";
          on-click = "nm-applet";
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
        "tray" = {
          icon-size = 21;
          spacing = 10;
          show-passive-items = true;
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "0xProto";
      }
      .module {
        background: ${background-950};
        color: ${text-100};
        border-radius: 1000px;
        padding-left: 20px;
        padding-right: 20px;
        margin-right: 5px;
        margin-left: 5px;
        font-size: 25px;
      }
      window#waybar {
        background: rgba(0,0,0,0);
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
        padding-left: 0px;
        padding-right: 0px;
      }
    '';
  };
}