{
  host,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
    # ./nvidia.nix
    inputs.vpn-confinement.nixosModules.default
  ];

  modules = {
    neovim.enable = true;
    server = {
      matrix.enable = true;
      immich.enable = true;
      sftpgo.enable = true;
      arr.enable = true;
      openssh.enable = true;
      cloudflared.enable = true;
      auth.enable = true;
      vaultwarden.enable = true;
    };
  };

  services = {
    vsftpd = {
      enable = true;
      writeEnable = true;
      localUsers = true;
      userlistEnable = true;
      userlist = ["luna"];
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

  home-manager.users.${host.userName} = {...}: {
    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/man
    ];
  };
}
