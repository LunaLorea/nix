{ config, pkgs, ... }:

{
    imports = [
        ./home-manager/git.nix
        .home-manager/studying.nix
    ];
}