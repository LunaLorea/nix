{
  host,
  lib,
  pkgs,
  colors,
  ...
}: let
  sway-floating = pkgs.writeShellScriptBin "floating" ''
    $@ &
    pid=$!

    ${pkgs.sway}/bin/swaymsg -t subscribe -m '[ "window" ]' \
      | jq --unbuffered --argjson pid "$pid" '.container | select(.pid == $pid) | .id' \
      | xargs -I '@' -- ${pkgs.sway}/bin/swaymsg '[ con_id=@ ] move scratchpad'

    subscription=$!

    echo Going into wait state

    # Wait for our process to close
    tail --pid=$pid -f /dev/null

    echo Killing subscription
    kill $subscription
  '';

  fuzzel-background = colors.base + "dd";
  fuzzel-text = colors.text + "ff";
  fuzzel-match = colors.teal + "ff";
  fuzzel-selection = colors.mauve + "dd";
  fuzzel-border = colors.mauve + "ff";
in {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  home-manager.users.${host.userName} = {...}: {
    imports = [
      ./sway.nix
      ./swaync.nix
      ./swaylock.nix
      ./waybar.nix
      ./cheatsheet.nix
    ];

    home.packages = [
      pkgs.wayshot
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.baobab
      pkgs.gnome-calculator
      pkgs.gnome-system-monitor
      pkgs.nautilus
      pkgs.networkmanagerapplet
      pkgs.qpwgraph
    ];

    services.blueman-applet = {
      enable = true;
    };
    services.network-manager-applet = {
      enable = true;
    };

    programs.kitty = {
      enable = true;
      themeFile = "Catppuccin-Macchiato";
      settings = {
        background_opacity = "0.85";
      };
      font.name = "JetBrainsMono Nerd Font";
    };
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          terminal = "kitty";
          layer = "overlay";
        };
        colors = {
          background = fuzzel-background;
          text = fuzzel-text;
          match = fuzzel-match;
          selection = fuzzel-selection;
          selection-text = fuzzel-text;
          selection-match = fuzzel-match;
          border = fuzzel-border;
        };
      };
    };

    # Enable audio applet that allows you to switch default audio devices
    services.pasystray.enable = true;

    services.swayosd.enable = true;

    home.keyboard = {
      layout = "us,ch,de";
      variant = "dvorak,nodeadkeys,neo2";
    };
  };

  systemd.services.bluetooth.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf --experimental"
  ];

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # polkit for sway
  security.polkit.enable = true;

  # Enable the gnome display manager
  services.displayManager.gdm.enable = true;

  # enables monitor hotplugging
  systemd.user.services.kanshi = {
    # description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Gnome Keyring for applications to store passwords and similar things.
  services.gnome.gnome-keyring.enable = true;

  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
}
