{
  host,
  pkgs,
  merremia,
  lib,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [sblast pulseaudioFull ffmpeg_7-headless jellyfin-desktop];

  modules = {
    silent-boot.enable = true;
    fingerprintreader.enable = true;
    sway.enable = true;
    _1password.enable = true;
    firefox.enable = true;
    neovim.enable = true;
  };

  merremia = let
  in {
    enable = true;
    systemd.enable = true;
    config.colors.colortheme = merremia.lib.importBase16.fromFile (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/tinted-theming/base16-schemes/refs/heads/main/rose-pine-dawn.yaml";
      hash = "sha256-TItRIXGUQ0SNrUWE+CBV2fgYypSx+voj9Zf6PVDSoDo=";
    });
  };
  home-manager.users.${host.userName} = {...}: {
    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/ncspot
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

    wayland.windowManager.sway.config = {
      output.eDP-1 = {
        scale = "1";
      };
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "eDP-1";
        }
      ];
    };
  };
}
