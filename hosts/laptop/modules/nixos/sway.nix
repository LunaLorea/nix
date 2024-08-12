{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      colors = {
        focused = {
          border = "#529699";
          background = "##040811";
          childBorder = "#529699";
          indicator = "#529699";
          text = "#ffffff";
        };
        focusedInactive = {
          border = "#529699";
          background = "##040811";
          childBorder = "#529699";
          indicator = "#529699";
          text = "#ffffff";
        };
      };
    };
  };
}