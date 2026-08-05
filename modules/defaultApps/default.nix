{
  host,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.defaultApps;
in
{
  options.modules.defaultApps = {
    enable = lib.mkEnableOption "the browser module";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      kitty
    ];

    systemd.services.bluetooth.serviceConfig.ExecStart = lib.mkForce [
      ""
      "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf --experimental"
    ];

    fonts.packages =
      [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    # enables monitor hotplugging
    systemd.user.services.kanshi = {
      # description = "kanshi daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kanshi}/bin/kanshi -c kanshi_config_file";
      };
    };

    programs.dconf.enable = true;

    # enable battery manager
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable sound with pipewire.
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    home-manager.users.${host.userName} = { ... }: {
      home.packages = [
        pkgs.nautilus
        pkgs.networkmanagerapplet
        pkgs.qpwgraph
        pkgs.pwvucontrol
        # Music player
        pkgs.feishin
        # Movie player
        pkgs.jellyfin-desktop
        pkgs.cinny-desktop
        pkgs.signal-desktop
        # Studying
        pkgs.obsidian
        pkgs.anki
      ];
      # automatically mount drives
      services.udiskie = {
        enable = true;
        settings = {
          # workaround for
          # https://github.com/nix-community/home-manager/issues/632
          program_options = {
            # replace with your favorite file manager
            file_manager = "${pkgs.nautilus}/bin/nautilus";
          };
        };
      };
      merremia = {
        enable = true;
        systemd.enable = true;
        colors.colortheme = inputs.merremia.lib.importBase16.fromAttrs config.lib.stylix.colors;
      };
      services.easyeffects.enable = true;

      services.network-manager-applet = {
        enable = true;
      };

      programs.kitty = {
        enable = true;
      };
      programs.fuzzel = {
        enable = true;

        settings = {
          main = {
            terminal = "kitty";
            layer = "overlay";
          };
        };
      };
    };
  };
}
