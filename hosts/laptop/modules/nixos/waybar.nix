{ lib, config, pkgs, ... }:

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
        modules-right = [ "battery" "network" "sway/language" "clock" "custom/notifications" ];

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
          on-click = "nm-connection-editor";
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
      };
    };
    style = ./waybar.css;
  };
}