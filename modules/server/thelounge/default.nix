{
  lib,
  config,
  ...
}: let
  cfg = config.modules.server.thelounge;
in {
  options.modules.server.thelounge = {
    enable = lib.mkEnableOption "irc webclient the lounge.";
  };

  config = lib.mkIf cfg.enable {
    services = {
      thelounge = {
        enable = true;
        plugins = [];
        extraConfig = {
          fileUpload = {
            enable = true;
          };
        };
      };

      nginx = {
        enable = true;

        # Use recommended settings
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        # other Nginx options
        virtualHosts."irc.lorea.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9000$request_uri";
            extraConfig =
              "proxy_set_header Connection \"upgrade\";"
              + "proxy_set_header Upgrade $http_upgrade;"
              + "proxy_set_header X-Forwarded-For $remote_addr;"
              + "proxy_set_header X-Forwarded-Proto $scheme;"
              + "client_max_body_size 0;";
          };
        };
      };
    };
  };
}
