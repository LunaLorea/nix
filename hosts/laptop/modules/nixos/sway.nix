{ lib, config, pkgs, ... }:

let
  colors-accent = "#529699";
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  home.packages = with pkgs; [
    fuzzel
    kitty
  ];

  home.keyboard =  {
    layout = "ch";
  };

  wayland.windowManager.sway = {
    enable = true;
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

      output = {
        eDP-1 = {
          scale = "1";
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
      input = {
        "*" = {
          xkb_layout = "ch";
        };
      };
      bars."*" = {
        position = "top";
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