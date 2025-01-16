{
  config,
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    ./home-manager/home-manager.nix
    ./nixos/nixos.nix
  ];
}
