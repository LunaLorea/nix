{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    usbutils
    # PDF viewer
    sioyek
    # Latex distro
    rubber
    texliveFull
  ];
}
