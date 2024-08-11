{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    pinentry-gtk2
  ];

  programs.gnupg = {
    enable = true;
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };
}