{ 
  config,
  pkgs,
  ... 
}: {
  imports = [

    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
    
  ];

  home-manager.users.${config.username} = { ... }: {

    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../modules/sway
      ../../modules/firefox.nix
      ../../modules/ncspot.nix
      ../../modules/neovim
      ../../modules/git.nix
      ../../modules/studying.nix
      ../../modules/nextcloud-client.nix
      ../../modules/man.nix
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
  };
}
