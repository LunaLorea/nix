{ config, pkgs, ... }:

{
    imports = [
        ./git.nix
        ./studying.nix
        ./nextcloud-client.nix
    ];
}