{
  config,
  pkgs,
  ...
}: let
  colors-background = "#060A13";
  colors-accent = "#529699";
  colors-accent-dark = "#4B7BA6";
  colors-waybar-text = "#efefef";
  modifier = config.wayland.windowManager.sway.config.modifier;
in {
  imports = [
    ./sway.nix
    ./swaync.nix
    ./waybar.nix
    ./swaylock.nix
  ];
}
