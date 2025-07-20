# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-stable,
  inputs,
  colors,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ./global-variables.nix
  ];

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  # Bootloader.
  # boot.loader.systemd-boot.enable = false;
  boot = {
    loader.efi.canTouchEfiVariables = true;

    loader.systemd-boot.enable = true;

    # loader.grub = {
    #   enable = true;
    #   # splashImage = /home/luna/.config/nix/media/splashscreen.png;
    #   # splashMode = "normal";
    #   efiSupport = true;
    #   device = "nodev";
    # };

    plymouth = {
      enable = true;
      theme = "hexagon_dots_alt";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hexagon_dots_alt"];
        })
      ];
    };
    
    

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  # programs.wshowkeys.enable = true;
  systemd.services = {
    plymouth-wait-for-animation = {
      # name = "plymouth-wait-for-animation";
      description = "Waits for Plymouth animation to finish";
      before = ["plymouth-quit.service" "display-manager.service"];
      wantedBy = ["plymouth-start.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/usr/bin/sleep 20";
      };
    };
  };

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  networking.hostName = "nixos"; # Define your hostname.
  
  networking.firewall = {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } { from = 1313; to = 1313; } ]; #kde-connect
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } { from = 1313; to = 1313; } ]; #kde-connect
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Blueman bluetooth manager
  services.blueman = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # polkit for sway
  security.polkit.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Enabling Fingerprint reader
  services.fprintd = {
    enable = true;
  };

  security.pam.services = {
    "swaylock" = {
      fprintAuth = true;
    };
  };

  # Configure console keymap
  console.keyMap = "sg";

  # Gnome Keyring for applications to store passwords and similar things.
  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.username} = {
    isNormalUser = true;
    description = config.username;
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit colors;
      pkgs-unstable = pkgs-stable;
    };
    users = {
      ${config.username} = import ./home.nix;
    };
  };

  # Install Steam
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable 1Password (Needs to be part of NixOS instead of Home Manager to allow for complete functionality)
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "luna" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [


    # File Manager
    pkgs.nautilus
    # Keyring
    pkgs.libsecret
    # wget
    pkgs.wget

    pkgs.openssh
    pkgs.networkmanagerapplet
    pkgs.zip

    # Easier to read man pages
    pkgs.tldr

    # Replacaement for ls
    pkgs.eza

    # used for mounting SAMBA shares
    pkgs.cifs-utils

    # Controlling PipeWire Audio/Video Streams
    pkgs.qpwgraph

    pkgs.lutris
    pkgs.pciutils
  ];


  # Set default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
