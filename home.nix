{
  host,
  merremia,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [merremia.homeModules.default];
  home.username = host.userName;
  home.homeDirectory = "/home/${host.userName}";

  xdg.enable = true;

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
