{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.cloudflared;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.cloudflared = {
    enable = mkEnableOption "cloudflare tunnel.";
  };
  config = mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "225e02f6-93e3-4020-ac7c-c493bcf69c26" = {
          credentialsFile = "/home/luna/.cloudflared/225e02f6-93e3-4020-ac7c-c493bcf69c26.json";
          default = "http_status:404";
        };
      };
    };
  };
}
