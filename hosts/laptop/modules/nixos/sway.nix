{ lib, config, pkgs, ... }:

let
  colors-background = "#060A13";
  colors-accent = "#529699";
  colors-accent-dark = "#4B7BA6";
  colors-waybar-text = "#efefef";
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  home.packages = with pkgs; [
    fuzzel
  ];

  programs.kitty = {
    enable = true;
  };

  home.keyboard =  {
    layout = "ch";
  };

  wayland.windowManager.sway = {
    enable = true;

    checkConfig = false;

    config = rec {

      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty";

      # Setup the colors for a beautiful sway enviornemnt
      colors = {
        focused = {
          border = colors-accent;
          background = "#040811";
          childBorder = colors-accent;
          indicator = colors-accent;
          text = "#ffffff";
        };
        focusedInactive = {
          border = colors-accent;
          background = "#040811";
          childBorder = colors-accent;
          indicator = colors-accent;
          text = "#ffffff";
        };
      };

      gaps = {
        inner = 8;
        #outer = 5;
      };

      

      output = {
        "*" = {
          bg = "/home/luna/.background-image.jpg fill";          
        };
        eDP-1 = {
          scale = "1";
        };
        DP-4 = {

        };
      };

      input = {
        "*" = {
          xkb_layout = "ch";
        };
        "type:touchpad" = {
          tap = "enabled";
          tap_button_map = "lrm";
          dwt = "enabled";
        };
      };

      # Change the Keybindings
      keybindings = {
        # Open Application Launcher
        "${modifier}+Space" = "exec fuzzel";
        # Open Console
        "${modifier}+Return" = "exec ${terminal}";
        # Reload Sway configs
        "${modifier}+Shift+c" = "reload";
        # Kill focused window
        "${modifier}+q" = "kill";

        # Workspaces:
        # Switching between Workspaces
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # Moving focused container to different workspace
        "${modifier}+Shift+1" = "move container to workspace number 1; workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2; workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3; workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4; workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5; workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6; workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7; workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8; workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9; workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10; workspace number 10";
      };
      
      bars = [ 
        #{
        #  command = "waybar";
        #}
      ];
      fonts = {
        names = [ "JetBrainsMono Nerd Font" "font-awesome"];
        size = 16.0;
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {

      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        margin-left = 8;
        margin-right = 8;
        margin-top = 8;
        margin-bottom = 0;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];

        modules-left = [ "sway/workspaces" ];
        modules-center = [ ];
        modules-right = [ "network" "clock" ];

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
        };

        "network" = {
          interval = 1;
          format-wifi = "{bandwidthTotalBytes:>3} ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format-wifi = "{ipaddr} ({signalStrength}%) ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "󰀦";
          on-click = "nm-connection-editor";
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "otf-font-awesome", "font-awesome";
      }
      .module {
        background: ${colors-background};
        color: ${colors-waybar-text};
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
        color: ${colors-waybar-text};
      }
      #clock {
      }
      #network {
        min-width: 110px;
      }

    '';
  };


  # enables monitor hotplugging
  systemd.user.services.kanshi = {
    # description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };
}