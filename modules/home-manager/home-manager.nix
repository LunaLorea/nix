{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./studying.nix
    ./nextcloud-client.nix
    ./pass.nix
    ./gpg.nix
    ./defaultApps.nix
    ./packages.nix
    ./neovim.nix
    ./firefox.nix
    ./neovim.nix
    ./shell.nix
    ./kde-connect.nix
  ];

  services.blueman-applet = {
    enable = true;
  };

  services.network-manager-applet = {
    enable = true;
  };
}
