{
  host,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = host.userName;
  home.homeDirectory = "/home/${host.userName}";

  imports = [
    ./global-variables.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    discord
    filezilla
    vlc
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
