{
  pkgs,
  host,
  inputs,
  ...
}:
{
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  qt.enable = true;
  modules = {
    affinity.enable = true;
    browser.enable = true;
    defaultApps.enable = true;
    gaming.enable = true;
    neovim.enable = true;
    passwordmanager.enable = true;
    server.arr.enable = false;
    shell.enable = true;
    silent-boot.enable = true;
    theming.enable = true;
    wm.enable = true;
  };

  fileSystems = {
    "/mnt/home-lab" = {
      device = "luna@192.168.178.26:/mnt/pool";
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
  };

  # Optional: Add your user to the "docker" group to run docker without sudo
  users.users.luna.extraGroups = [ "docker" ];

  environment.defaultPackages = with pkgs; [
    usbutils
    krita
    signal-desktop
  ];
  environment.systemPackages = with pkgs; [
    gparted
    inkscape
    cifs-utils
    libation
    slack
  ];
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = "/home/${host.userName}/.searxng.env";
    settings = {
      general = {
        debug = false;
      };
      server = {
        bind_address = "127.0.0.1";
      };
    };
  };

  hardware.opentabletdriver.enable = true;

  programs.wshowkeys.enable = true;

  home-manager.users.${host.userName} = { ... }: {
    merremia = {
      enable = true;
      systemd.enable = true;
      config = {
        monitors = [
          {
            name = "DP-1";
            scale = 1.0;
          }
        ];
      };
      modules = {
        bar = {
          monitors = {
            "HDMI-A-1" = {
              widgets = {
                left = [ "workspaces" ];
              };
            };
          };
        };
      };
    };
    qt.enable = true;

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

      picard
    ];
    wayland.windowManager.mango = {
      enable = true;

      settings = {
        monitorrule = [
          "name:HDMI-A-1,width:1920,height:1080,x:0,y:0"
          "name:DP-2,width:1920,height:1080,refresh:144.0,x:1920,y:0"
        ];
      };
    };

    programs.zsh.shellAliases = {
      # Reboot into windows
      reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
    };
  };
}
