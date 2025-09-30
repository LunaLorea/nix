{
  custom-modules,
  pkgs,
  host,
  lib,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  modules = {
    sway.enable = true;
    silent-boot.enable = true;
    gaming.enable = true;
    _1password.enable = true;
    firefox.enable = true;
    quickshell.enable = true;
  };

  environment.defaultPackages = with pkgs; [
    usbutils
  ];

  programs.wshowkeys.enable = true;

  home-manager.users.${host.userName} = {...}: {
    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/neovim
      ../../homemanager-modules/git
      ../../homemanager-modules/studying
      ../../homemanager-modules/nextcloud-client
      ../../homemanager-modules/man
      ../../homemanager-modules/ncspot
    ];

    home.packages = with pkgs; [
      jq

      sioyek

      rubber
      texliveFull

      discord
      filezilla
      vlc

      heroic
      gamemode
      mangohud
    ];

    wayland.windowManager.sway.config = {
      output = {
        HDMI-A-1 = {
          scale = "1";
          position = "0 0";
          transform = "270";
        };
        DP-2 = {
          scale = "1";
          position = "1080 400";
          mode = "1920x1080@144Hz";
          adaptive_sync = "on";
          modeline = "452.50  1920 2088 2296 2672  1080 1083 1088 1177 -hsync +vsync";
        };
        DP-3 = {
          scale = "1";
          position = "3000 400";
        };
      };

      workspaceOutputAssign = [
        {
          workspace = "10";
          output = "HDMI-A-1";
        }
        {
          workspace = "1";
          output = "DP-2";
        }
        {
          workspace = "2";
          output = "DP-3";
        }
      ];

      startup = [
        # Start 1Password in the background
        {command = "swaymsg exec discord && sleep 3 && swaymsg splitv && swaymsg exec firefox -P messages -no-remote --name Firefox-message && swaymsg splith";}
      ];
    };

    programs.zsh.shellAliases = {
      # Reboot into windows
      reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
    };
  };
}
