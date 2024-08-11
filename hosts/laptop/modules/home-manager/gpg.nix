{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
    pinentry-gtk2
  ];

  programs.gpg = {
    enable = true;
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };
}