{ config, pkgs, ... }:

{
  programs.password-store = {
    enable = true;
    package = pkgs.pass;
    settings = {
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
    };
  };
}