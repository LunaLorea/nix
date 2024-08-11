{ config, pkgs, ... }:

{
    programs.git = {
      enable = true;
      userEmail = "luna.zehnder@laptop.nix";
      userName = "Luna";
    };
}