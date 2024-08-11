{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
    pinentry-gtk2
  ];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
}