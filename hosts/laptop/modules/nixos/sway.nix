
{
  let
    colors-accent = #529699;
  in
  outputs = { config, pkgs, ... }: {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        colors = {
          focused = {
            border = colors-accent;
            background = "#040811";
            childBorder = colors-accent;
            indicator = colors-accent;
            text = "#ffffff";
          };
          focusedInactive = {
            border = colors-accent;
            background = "#040811";
            childBorder = colors-accent;
            indicator = colors-accent;
            text = "#ffffff";
          };
        };
      };
    };
  };
}