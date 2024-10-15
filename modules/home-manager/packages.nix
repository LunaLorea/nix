{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    gimp
    taskwarrior3
    github-desktop
    chromium
    musescore
    usbutils
    # PDF viewer
    sioyek
    # Latex distro
    rubber
    texliveFull
    spotify
    quickemu
  ];
}
