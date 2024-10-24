{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home-manager/home-manager.nix
    ./nixos/nixos.nix
  ];
}
