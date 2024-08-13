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
        "${modifier}+Space" = "exec fuzzel";
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+q" = "kill";
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