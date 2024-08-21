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

  programs.fuzzel = {
    enable = true;
    
    settings = {
      main = {
        terminal = "${terminal}";
        layer = "overlay";
      };
      colors = {
        background = background-800;
        text = text-100;
        match = primary-400;
        selection = background-600;
        selection-text = text-100;
        selection-match = primary-400;
        border = accent-400;
      };
    };
  };

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
          border = accent-400;
          background = background-900;
          childBorder = accent-300;
          indicator = accent-400;
          text = text-200;
        };
        focusedInactive = {
          border = accent-400;
          background = background-900;
          childBorder = accent-300;
          indicator = accent-400;
          text = text-200;
        };
      };

      gaps = {
        inner = 8;
        #outer = 5;
      };

      window = {
        titlebar = false;
        border = 4;
      };

      output = {
        "*" = {
          bg = "/home/luna/.config/nix/media/background-image.png fill";          
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
        # Open Notification Center
        "${modifier}+Shift+n" = "exec swaync-client -t -sw";
        # Lock Sway
        "${modifier}+l" = "exec swaylock";

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
        {
          command = "waybar";
        }
      ];
      fonts = {
        names = [ "JetBrainsMono Nerd Font" "0xProto Nerd Font"];
        size = 16.0;
      };
    };
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