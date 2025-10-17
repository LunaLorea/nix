{
  host,
  pkgs,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  modules = {
    silent-boot.enable = true;
    sway.enable = true;
    fingerprintreader.enable = true;
    _1password.enable = true;
    firefox.enable = true;
    quickshell = {
      enable = true;
      developerMode.enable = true;
      monitors = {
        "*" = {
          barWidgets = {
            left = [
              "workspaces"
            ];
          };
        };
        "eDP-1" = {
          scale = 0.8;
        };
      };
    };
  };

  home-manager.users.${host.userName} = {...}: {
    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
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
