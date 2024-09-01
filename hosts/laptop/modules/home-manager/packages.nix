{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    gimp
    taskwarrior3
  ];
}
