{
  config,
  pkgs,
  host,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
    
  ];

  home-manager.users.${host.userName} = { ... }: {

    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../modules/sway
      ../../modules/neovim
      ../../modules/shell.nix
      ../../modules/git.nix
      ../../modules/studying.nix
      ../../modules/nextcloud-client.nix
      ../../modules/man.nix
      ../../modules/firefox.nix
      ../../modules/ncspot.nix
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
      steam
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
      };
      DP-2 = {
        scale = "1";
        position = "3000 400";
      };
    };
  };
}
