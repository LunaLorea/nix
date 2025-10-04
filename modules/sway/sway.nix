{
  lib,
  colors,
  ...
}: let
in {
  wayland.windowManager.sway = {
    enable = true;

    checkConfig = false;

    extraConfig = ''
      # Enable locking on closing the lid
      bindswitch --reload --locked lid:on lock

      # Applications that should float on start
      for_window [app_id=".blueman-manager-wrapped"] move scratchpad; scratchpad show
      for_window [app_id="nm-connection-editor"] move scratchpad; scratchpad show
      for_window [class="1Password"] move scratchpad; scratchpad show
      for_window [title="ncspot"] move scratchpad; scratchpad show
      for_window [window_type="dialog"] floating enable
      for_window [window_role="dialog"] floating enable
      for_window [app_id="Firefox-calendar"] floating enable
      assign [class="discord"] workspace number 10
      assign [app_id="Firefox-messages"] workspace number 10
    '';

    config = let
      sway-colors = {
        focused = {
          border = "#00000000";
          background = colors.base;
          childBorder = colors.mauve;
          indicator = colors.red;
          text = colors.text;
        };
        focusedInactive = {
          border = "#000000";
          background = colors.base;
          childBorder = colors.lavender;
          indicator = colors.red;
          text = colors.text;
        };
        unfocused = {
          border = "#00000000";
          background = colors.base;
          childBorder = "#00000000";
          indicator = colors.red;
          text = colors.text;
        };
      };
    in rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty";

      colors = sway-colors;
      # Setup the colors for a beautiful sway enviornemnt

      gaps = {
        inner = 8;
        smartBorders = "on";
      };

      window = {
        titlebar = false;
        border = 4;
      };

      floating.criteria = [
        {
          title = "Smile";
        }
      ];

      output = {
        "*" = {
          bg = ''${builtins.path {path = ../../media/background-image.png;}} fill'';
        };
      };

      defaultWorkspace = "1";

      input = {
        "*" = {
          xkb_layout = "de,ch,us";
          xkb_variant = "noted,de,dvorak";
        };
        "type:touchpad" = {
          tap = "enabled";
          tap_button_map = "lrm";
          dwt = "enabled";
          middle_emulation = "enabled";
        };
      };

      # Commands to be executed on startup
      startup = [
        # Start 1Password in the background
        {command = "1password --silent";}
      ];

      # Change the Keybindings
      keybindings = {
        # Open Appliation Launcher
        "${modifier}+Space" = "exec fuzzel";
        # Open Firefox
        "${modifier}+f" = "exec firefox";
        # Open ncspot (tui spotify)
        "${modifier}+c" = "exec switch-cheatsheet";

        # Open Console
        "${modifier}+t" = "exec ${terminal}";
        # Open Smile emoji picker
        "${modifier}+Comma" = "exec smile";
        # Reload Sway configs
        "${modifier}+Shift+c" = "reload";
        # Kill focused window
        "${modifier}+q" = "kill";
        # Open Notification Center
        "${modifier}+Shift+n" = "exec swaync-client -t -sw";
        # Lock Sway
        "${modifier}+Grave" = "lock";
        # Change focused Window
        "Shift+Alt+Tab" = "[con_id=$(swaymsg -t get_tree | ~/.config/nix/scripts/alttab t)] focus";
        "${modifier}+s" = "splitv";
        "${modifier}+Shift+s" = "splith";
        "${modifier}+Shift+Return" = "move scratchpad";
        "${modifier}+Alt+Return" = "floating toggle";
        "${modifier}+Return" = "scratchpad show";
        "${modifier}+Alt+Space" = "input type:keyboard xkb_switch_layout next";

        "Alt+Tab" = "[con_id=$(swaymsg -t get_tree | ~/.config/nix/scripts/alttab t)] focus";
        # Open Messages App
        "${modifier}+m" = "exec firefox -P messages -no-remote";
        # Open 1Password Quick Access
        "${modifier}+p" = "exec 1password --quick-access";

        #FN Audiocontroll
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioNext" = "exec swayosd-client --playerctl=next";
        "XF86AudioPrev" = "exec swayosd-client --playerctl=prev";
        "XF86AudioPlay" = "exec swayosd-client --playerctl=play-pause";

        # FN Brightnesscontroll
        "XF86MonBrightnessUp " = "exec swayosd-client --brightness=raise";
        "XF86MonBrightnessDown " = "exec swayosd-client --brightness=lower";

        # Start ncspot a tui spotify client
        "XF86AudioMedia" = "exec floating ${terminal} ncspot; scratchpad show";

        # Make a screenshot
        "Print" = ''exec wayshot -s "$(slurp)" --stdout | wl-copy'';

        # Move focus
        "${modifier}+l" = "focus right";
        "${modifier}+h" = "focus left";
        "${modifier}+k" = "focus up";
        "${modifier}+j" = "focus down";

        # Move containers within workspace
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+j" = "move down";

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

        # Rotate through workspaces on current monitor
        "${modifier}+Left" = "workspace prev_on_output";
        "${modifier}+Right" = "workspace next_on_output";

        # Rotate Containers through workspaces on current monitor
        "${modifier}+Shift+Right" = "move container to workspace next_on_output; workspace next_on_output;";
        "${modifier}+Shift+Left" = "move container to workspace prev_on_output; workspace prev_on_output;";

        # Move Workspace to other monitors based on direction
        "${modifier}+Control+Left" = "move workspace to output left";
        "${modifier}+Control+Right" = "move workspace to output right";
        "${modifier}+Control+Up" = "move workspace to output up";
        "${modifier}+Control+Down" = "move workspace to output down";
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      fonts = {
        names = ["JetBrainsMono Nerd Font" "0xProto Nerd Font"];
        size = 16.0;
      };
    };
  };
}
