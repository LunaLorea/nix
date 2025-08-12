{
  config,
  pkgs,
  host,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
    
    ../../nix-modules/steam
  ];

  home-manager.users.${host.userName} = { ... }: {

    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/sway
      ../../homemanager-modules/neovim
      ../../homemanager-modules/shell
      ../../homemanager-modules/git
      ../../homemanager-modules/studying
      ../../homemanager-modules/nextcloud-client
      ../../homemanager-modules/man
      ../../homemanager-modules/firefox
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
