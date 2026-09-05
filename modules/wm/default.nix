{
  config,
  lib,
  pkgs,
  inputs,
  host,
  ...
}:
let
  cfg = config.modules.wm;
in
{
  imports = [ inputs.mango.nixosModules.mango ];

  options.modules.wm = {
    enable = lib.mkEnableOption "MangoWM configuration";

    wantedModes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "tile"
        "scroller"
        "deck"
        "monocle"
      ];
    };
  };

  config = lib.mkIf cfg.enable {

    programs.mango = {
      enable = true;
      addLoginEntry = true;
    };

    # Enable the ly display manager
    services.displayManager.ly = {
      enable = true;
      settings = {
        default_input = "password";
        animation = "dur_file";
        dur_file_path = "${pkgs.fetchurl {
          url = "https://codeberg.org/fairyglade/ly-community/raw/commit/2f22cfaf7d17598c8f60f562d56e16d74b6c99ab/animations/dur/blackhole-smooth-240x67.dur";
          hash = "sha256-wo3FzPtngCsg/bRSDTYHQqKnMp4vY+Btm14vakJERBU=";
        }}";
        full_color = true;
      };
    };
    # kmscon tty
    services.kmscon = {
      enable = true;
      extraOptions = "--term xterm-256color";
      config = { };
    };

    home-manager.users.${host.userName} = { ... }: {
      imports = [ inputs.mango.hmModules.mango ];
      home.packages = with pkgs; [
        brightnessctl # brightness control
        wireplumber # volume control

        wl-clipboard # wayland clipboard management

        unipicker # unicode picker

        grim # screenshot tool
        slurp # screen area selection
      ];

      home.keyboard = {
        layout = "de,ch";
        variant = "noted";
      };

      services = {
        playerctld.enable = true; # playback control
        wl-clip-persist.enable = true; # clipboard persistence
        cliphist.enable = true; # clipboard history
      };

      wayland.windowManager.mango = {
        enable = true;

        settings =
          let
            directions = [
              "left"
              "right"
              "up"
              "down"
            ];
          in
          {
            xkb_rules_layout = "${config.home-manager.users.${host.userName}.home.keyboard.layout}";
            xkb_rules_variant = "${config.home-manager.users.${host.userName}.home.keyboard.variant}";

            edge_scroller_pointer_focus = 0;
            scroller_default_proportion = 0.67;

            autostart_sh = ''
              merremia &
              merremia-wallpaper &
            '';

            binds = [
              "SUPER,z,killclient"
              "SUPER+SHIFT,z,killclient,force"
              "SUPER,r,reload_config"
              "SUPER,k,setkeymode,window"

              # Overview
              "SUPER,Tab,toggleoverview"

              # Screenshot
              "SUPER+SHIFT,s,spawn_shell,grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy"
              "NONE,Print,spawn_shell,grim -g \"$(slurp -o)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy"

              # Launcher
              "SUPER,Space,spawn,fuzzel"

              # Browser
              "Super,e,spawn,zen-beta"

              # Clipboard
              "SUPER,v,spawn_shell,cliphist list | rofi -dmenu | cliphist decode | wl-copy"

              # Screen lock
              "SUPER,L,spawn,swaylock --daemonize"

              # Brightness controls
              "NONE,XF86MonBrightnessUp,spawn,brightnessctl set 5%+"
              "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 5%-"

              # Media controls
              "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
              "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
              "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
              "NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle"
              "NONE,XF86AudioNext,spawn,playerctl next"
              "NONE,XF86AudioPrev,spawn,playerctl previous"
              "NONE,XF86AudioPlay,spawn,playerctl play-pause"
              "SHIFT,XF86AudioRaiseVolume,spawn,playerctl volume 0.05+"
              "SHIFT,XF86AudioLowerVolume,spawn,playerctl volume 0.05-"

              # Terminal
              "SUPER,i,spawn,kitty"

              # Scratchpad
              "SUPER,RETURN,toggle_scratchpad"
              "SUPER+SHIFT,RETURN,minimized"
              "SUPER+CTRL,RETURN,restore_minimized"

              # Floating
              "SUPER,f,togglefloating"
            ];

            bind =
              # Tags
              [
                "SUPER+ALT,left,viewtoleft_have_client"
                "SUPER+ALT,right,viewtoright_have_client"
                "SUPER+SHIFT+ALT,left,viewtoleft"
                "SUPER+SHIFT+ALT,right,viewtoright"
                "SUPER+ALT,up,exchange_stack_client,prev"
                "SUPER+ALT,down,exchange_stack_client,next"
                "SUPER,0,view,0"
              ]
              ++ (lib.concatMap (x: [
                "SUPER,${toString x},view,${toString x}" # switch to tag
                "SUPER+CTRL,${toString x},toggleview,${toString x}" # add tag to view
                "SUPER+SHIFT,${toString x},tag,${toString x},0" # tag window
              ]) (lib.range 1 9))
              ++ (lib.concatMap (x: [
                "SUPER,${x},focusdir,${x}"
                "SUPER+SHIFT,${x},exchange_client,${x}"
                "SUPER+CTRL,${x},focusmon,${x}"
                "SUPER+CTRL+SHIFT,${x},tagmon,${x}"
              ]) directions);

            mousebind = [
              "SUPER,btn_left,moveresize,curmove"
              "SUPER,btn_right,moveresize,curresize"
            ];

            keymode =
              lib.mapAttrs (n: v: v // { bindr = (v.bindr or [ ]) ++ [ "Super,Super_L,setkeymode,default" ]; })
                {
                  window = {
                    bind = [
                      "SUPER,Space,togglefullscreen"
                      "SUPER+SHIFT,Space,togglefakefullscreen"
                    ]
                    ++ lib.flatten (
                      lib.zipListsWith (x: y: [
                        "SUPER,${toString x},setlayout,${y}"
                        "SUPER+SHIFT,${toString x},setlayout,vertical_${y}"
                      ]) (lib.range 1 (lib.length cfg.wantedModes)) cfg.wantedModes
                    );
                  };
                };

            gesturebind = [
              "SUPER,LEFT,3,viewtoleft_have_client"
              "SUPER,RIGHT,3,viewtoright_have_client"
              "NONE,UP,3,toggleoverview"
              "NONE,DOWN,3,toggleoverview"
            ]
            ++ lib.concatMap (x: [ "NONE,${lib.toUpper x},4,focusdir,${x}" ]) directions;

            axisbind = [
              "SUPER,UP,focusdir,up"
              "SUPER,UP,focusdir,left"
              "SUPER,DOWN,focusdir,down"
              "SUPER,DOWN,focusdir,right"
            ];
          }
          // (lib.optionalAttrs (config.stylix.enable) (
            with config.lib.stylix.colors;
            let
              hexToMango = hex: transparency: "0x${hex}${transparency}";
            in
            {
              rootcolor = hexToMango base00 "ff";
              bordercolor = hexToMango base02 "ff";
              dropcolor = hexToMango base02 "55";
              splitcolor = hexToMango base03 "ff";
              focuscolor = hexToMango base01 "ff";
            }
          ));
      };
    };
  };
}
