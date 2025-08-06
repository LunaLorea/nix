{
  pkgs,
  ...
}:
let
  lightdm-web-greeter = import ''${builtins.path {path = custom-pkgs/lightdm-web-greeter.nix;}}'' { inherit pkgs; };
in
{
 services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
      enable = true;
    };
  };
}
