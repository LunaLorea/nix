{
  config,
  ...
}: {
  home-manager = {
    users = {
      ${config.username} = import ./desktop-homemanager.nix;
    };
  };
}
