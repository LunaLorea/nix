{
  host,
  pkgs,
  config,
  ...
}:
{
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  modules = {
    neovim.enable = true;
    server = {
      arr.enable = true;
      attic.enable = true;
      auth.enable = true;
      cloudflared.enable = true;
      immich.enable = true;
      mastodon.enable = true;
      matrix.enable = true;
      openssh.enable = true;
      searxng.enable = true;
      sftpgo.enable = true;
      thelounge.enable = true;
      vaultwarden.enable = true;
      git = {
        forgejo.enable = true;
        runner.enable = true;
      };
    };
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  boot = {
    kernelModules = [
      "nvidia"
      "i915"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelParams = [ "nvidia-drm.fbdev=1" ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # see the note above
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  services = {
    vsftpd = {
      enable = true;
      writeEnable = true;
      localUsers = true;
      userlistEnable = true;
      userlist = [ "luna" ];
    };
    couchdb = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    kitty
    git
  ];

  # needed for lvm cache
  boot.initrd.kernelModules = [
    "dm-cache-default"
  ];

  home-manager.users.${host.userName} = { ... }: {
    # Modules
    imports = [
    ];
  };
}
