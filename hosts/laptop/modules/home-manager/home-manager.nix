{ config, pkgs, ... }:

{
    imports = [
        ./git.nix
        ./studying.nix
        ./nextcloud-client.nix
        ./pass.nix
        ./gpg.nix
        ./defaultApps.nix
        ./packages.nix
    ];
}