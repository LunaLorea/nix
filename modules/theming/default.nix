{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.theming;
in
{
  options.modules.theming = {
    enable = lib.mkEnableOption "theming provided by stylix";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = "dark";
      autoEnable = true;
      image = pkgs.fetchurl {
        url = "https://github.com/Narmis-E/onedark-wallpapers/blob/main/minimal/od_error.png?raw=true";
        hash = "sha256-OItnngkLB8TPUtbiq4UHydcqIlOPGR59GZwxwiBA3ps=";
      };
      base16Scheme = ./onedark.yaml;
    };
  };
}
