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
  };

  environment.defaultPackages = with pkgs; [
    usbutils
    libsForQt5.xp-pen-g430-driver
  ];

  programs.wshowkeys.enable = true;

  home-manager.users.${host.userName} = {...}: {
    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/neovim
      ../../homemanager-modules/shell
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

    wayland.windowManager.sway.config.output = {
      HDMI-A-1 = {
        scale = "1";
        position = "0 0";
        transform = "270";
      };
      DP-1 = {
        scale = "1";
        position = "1080 400";
        mode = "1920x1080@144Hz";
      };
      DP-2 = {
        scale = "1";
        position = "3000 400";
      };
    };

    programs.zsh.shellAliases = {
      # Reboot into windows
      reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
    };
  };
}
