{
  lib,
  config,
  pkgs,
  ...
}: let
  text-100 = "#e5daf1";
  text-200 = "#cbb6e2";
  background-600 = "#662d9f";
  background-800 = "#331650";
  background-900 = "#190b28";
  primary-400 = "#975ad8";
  accent-400 = "#964ae8";
  fuzzel-background = background-800 + "dd";
  fuzzel-text = text-100 + "ff";
  fuzzel-match = primary-400 + "ff";
  fuzzel-selection = background-600 + "dd";
  fuzzel-border = accent-400 + "ff";

  modifier = config.wayland.windowManager.sway.config.modifier;
  lock = ''
           exec swaylock \
    --screenshots \
    --clock \
    --indicator \
    --indicator-radius 100 \
           --indicator-thickness 7 \
    --effect-blur 7x5 \
           --effect-vignette 0.5:0.5 \
           --fade-in 0.2
  '';
in {
  home.packages = with pkgs; [
    wayshot
    slurp
    wl-clipboard
  ];
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        terminal = "kitty";
        layer = "overlay";
      };
      colors = {
        background = fuzzel-background;
        text = fuzzel-text;
        match = fuzzel-match;
        selection = fuzzel-selection;
        selection-text = fuzzel-text;
        selection-match = fuzzel-match;
        border = fuzzel-border;
      };
    };
  };

  # Enable audio applet that allows you to switch default audio devices
  services.pasystray.enable = true;


  services.swayosd.enable = true;

  home.keyboard = {
    layout = "ch,dvorak";
  };

  wayland.windowManager.sway = {
    enable = true;

    checkConfig = false;

    extraConfig = ''
      bindswitch --reload --locked lid:on ${lock}
    '';
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty";

      # Setup the colors for a beautiful sway enviornemnt
      colors = {
        focused = {
          border = "#ffffff30";
          background = background-900;
          childBorder = accent-400;
          indicator = accent-400;
          text = text-200;
        };
        focusedInactive = {
          border = "#ffffff30";
          background = background-900;
          childBorder = "#ffffff30";
          indicator = accent-400;
          text = text-200;
        };
      };

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
        eDP-1 = {
          scale = "1"; 
        };
        HDMI-A-1 = {
          position = "1920 0";
          transform = "270";
        };
        HDMI-A-2 = {
          position = "0 700";
        };
      };

      defaultWorkspace = "1";

      input = {
        "*" = {
          xkb_layout = "ch,us";
          xkb_variant = "de,dvorak";
        };
        "type:touchpad" = {
          tap = "enabled";
          tap_button_map = "lrm";
          dwt = "enabled";
        };
      };

      # Commands to be executed on startup
      startup = [
        # Start 1Password in the background
        {command = "1password --silent";}
      ];

      # Change the Keybindings
      keybindings = {
        # Open Application Launcher
        "${modifier}+Space" = "exec fuzzel";
        # Open Firefox
        "${modifier}+f" = "exec firefox";

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
        "${modifier}+Section" = lock;
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
        "${modifier}+F11" = "exec brightnessctl set 10%-";
        "${modifier}+F12" = "exec brightnessctl set 10%+";
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";

        # Screenshots
        # Copy Selection to Clipboard
        "${modifier}+F2" = ''exec wayshot -s "$(slurp)" --stdout | wl-copy'';

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

  # enables monitor hotplugging
  systemd.user.services.kanshi = {
    # description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };
}
