{
  host,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    sblast
    pulseaudioFull
    ffmpeg_7-headless
    jellyfin-desktop
    rclone
  ];

  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
    rootless.enable = false;
  };

  # Optional: Add your user to the "docker" group to run docker without sudo
  #users.users.${host.userName}.extraGroups = [ "docker" ];

  modules = {
    silent-boot.enable = true;
    fingerprintreader.enable = true;
    sway.enable = true;
    _1password.enable = true;
    firefox.enable = true;
    neovim.enable = true;
    gaming.enable = true;
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

    programs.kitty.font.size = lib.mkForce 16;

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
