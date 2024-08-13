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
      keybindings = {
        # Open Application Launcher
        "${modifier}+Space" = "exec fuzzel";
        # Open Console
        "${modifier}+Return" = "exec kitty";
        # Reload Sway configs
        "${modifier}+Shift+c" = "reload";
        # Kill focused window
        "${modifier}+q" = "kill";

        # Workspaces:
        # Switching between Workspaces
        "${modifier}+1" = "workspace number $ws1";
        "${modifier}+2" = "workspace number $ws2";
        "${modifier}+3" = "workspace number $ws3";
        "${modifier}+4" = "workspace number $ws4";
        "${modifier}+5" = "workspace number $ws5";
        "${modifier}+6" = "workspace number $ws6";
        "${modifier}+7" = "workspace number $ws7";
        "${modifier}+8" = "workspace number $ws8";
        "${modifier}+9" = "workspace number $ws9";
        "${modifier}+0" = "workspace number $ws10";
      };
      input = {
        "*" = {
          xkb_layout = "ch";
        };
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