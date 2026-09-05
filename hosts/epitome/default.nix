{
  host,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    sblast
    pulseaudioFull
    ffmpeg_7-headless
    jellyfin-desktop
    rclone
  ];
  fileSystems = {
    "/mnt/home-lab" = {
      device = "luna@sftpgo.wuffli.art:/mnt/pool";
      fsType = "sshfs";
      options = [
        "nodev"
        "noatime"
        "allow_other"
        "IdentityFile=/root/.ssh/id_ed25519"
      ];
    };
  };
  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
    rootless.enable = false;
  };
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  modules = {
    _1password.enable = true;
    browser.enable = true;
    defaultApps.enable = true;
    fingerprintreader.enable = true;
    firefox.enable = true;
    gaming.enable = true;
    neovim.enable = true;
    silent-boot.enable = true;
    theming.enable = true;
    wm.enable = true;
  };

  services.upower.enable = true;

  home-manager.users.${host.userName} = { ... }: {
    # Modules
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
