{
  host,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.defaultApps;
in
{
  options.modules.affinity = {
    enable = lib.mkEnableOption "affinity";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];
    nix.settings = {
      extra-substituters = [ "https://cache.forall.systems" ];
      extra-trusted-public-keys = [
        "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
      ];
    };

    home-manager.users.${host.userName} = { ... }: {
      home.packages = [ pkgs.affinity-v3 ];
    };
  };
}
