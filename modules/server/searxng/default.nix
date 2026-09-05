{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.searxng;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.searxng = {
    enable = mkEnableOption "searxng.";
  };
  config = mkIf cfg.enable {
    services.searx = {
      enable = true;
      environmentFile = "/run/secrets/hosts/myriorama/searxng";
      settings = {
        server = {
          port = 8186;
          bind_address = "127.0.0.1";
        };
      };
      openFirewall = true;
    };
    sops.secrets = {
      "hosts/myriorama/searxng".owner = "searx";
    };
  };
}
