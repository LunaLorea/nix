{ config, pkgs, ... }:

{
    imports = [
        ./sway.nix
    ];
    environment.systemPackages = with pkgs; [
        networkmanagerapplet
    ];
}