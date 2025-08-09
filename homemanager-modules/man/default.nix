{ config, pkgs, ... }:

{
  programs.man = {
    enable = true;
    generateCaches = true;
  };

  manual.manpages.enable = true;
}
