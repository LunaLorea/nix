{ 
  host,
  pkgs,
  ... 
}: {
  imports = [

    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
    
    ../../nix-modules/silent-boot
  ];

  home-manager.users.${host.userName} = { ... }: {

    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/sway
      ../../homemanager-modules/firefox
      ../../homemanager-modules/ncspot
      ../../homemanager-modules/neovim
      ../../homemanager-modules/git
      ../../homemanager-modules/studying
      ../../homemanager-modules/nextcloud-client
      ../../homemanager-modules/man
    ];

    home.packages = with pkgs; [
      jq

      sioyek

      rubber
      texliveFull

      discord
      filezilla
      vlc
    ];

    programs.kitty.font.size = 16;
 
    wayland.windowManager.sway.config.output.eDP-1 = {
      scale = "1";
      };
  };
}
