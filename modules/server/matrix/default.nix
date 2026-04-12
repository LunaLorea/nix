{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.server.matrix;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.matrix = {
    enable = mkEnableOption "matrix stack";
  };
  config = mkIf cfg.enable {
    services.matrix-continuwuity = {
      enable = true;
      settings = {
        global = {
          server_name = "lorea.dev";
          # Listening on localhost by default
          # address and port are handled automatically
          allow_registration = false;
          allow_encryption = true;
          allow_federation = true;
          trusted_servers = ["matrix.org"];
          well_known = {
            client = "https://lorea.dev";
            server = "lorea.dev:443";
          };
        };
      };
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@lunalorea.ch";
    };
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [80 443 8448 6167];
    };
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      # other Nginx options
      virtualHosts."lorea.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:6167$request_uri";
          proxyWebsockets = true; # needed if you need to use WebSocket
          extraConfig =
            "proxy_headers_hash_max_size 2048;"
            + "proxy_headers_hash_bucket_size 128;"
            + "proxy_set_header Host $host;"
            + "proxy_set_header X-Real-IP $remote_addr;"
            + "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
            + "proxy_set_header X-Forwarded-Proto $scheme;";
        };
      };
    };
  };
}
