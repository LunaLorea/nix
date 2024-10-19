{ config, pkgs, lib, ... }:
{
  options = with lib; with types; {
    username = mkOption { type = str; };
  };


  config = {
   username = "luna";
  };
}
