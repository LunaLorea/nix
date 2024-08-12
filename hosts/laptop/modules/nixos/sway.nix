{ config, pkgs, ... }:

let
  colors-accent = "#529699";
in
{
  home.packages = with pkgs; [
    fuzzel
  ];


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
      bindsym $mod+Space exec fuzzel;


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
