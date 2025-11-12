{
  pkgs,
  host,
  ...
}: {
  imports = [
    # Hardware Configuration for this spcific device
    ./hardware-configuration.nix
  ];

  modules = {
  };

  home-manager.users.${host.userName} = {...}: {
    # Modules
    imports = [
      # Window manager plus all the additional pkgs like waybar
      ../../homemanager-modules/neovim
      ../../homemanager-modules/git
      ../../homemanager-modules/man
    ];
  };
}
