{ config, lib, ... }:
let
  cfg = config.modules.server.attic;
in
{
  options.modules.server.attic = {
    enable = lib.mkEnableOption "attic nix cache";
  };
  config = lib.mkIf cfg.enable {
    services = {
      atticd = {
        enable = true;

        # File containing the server token in the following format:
        #   ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=<...>
        # You can generate the token by running the following command:
        #   openssl genrsa -traditional 4096 | base64 -w0
        environmentFile = "/run/secrets/hosts/myriorama/attic/token";
        settings = {
          # Listen on some port. Replace it!
          listen = "[::]:8060";
          # The two lines below should be set to the URL where your
          # Attic cache will be available.
          allowed-hosts = [ "cache.lorea.dev" ];
          # Apparently it's very important this ends in a "/"
          api-endpoint = "https://cache.lorea.dev/";
          jwt = { };
          database = {
            # I used Postgres here, but if you leave it empty
            # it will use an in-memory SQLite DB instead.
            url = "postgresql://atticd@127.0.0.1/atticd?host=/run/postgresql";
            heartbeat = true;
          };
          storage = {
            # You could also use S3 here. But nah lol shit's expensive.
            type = "local";
            # Leave this empty to use the default path,
            # or change it to some path that Attic can write to.
            path = "/mnt/pool/attic";
          };
        };
      };

      postgresql = {
        enable = true;
        ensureDatabases = [
          "atticd"
        ];
        ensureUsers = [
          {
            name = "atticd";
            ensureDBOwnership = true;
          }
        ];
      };
      nginx = {
        enable = true;

        # Use recommended settings
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        # other Nginx options
        virtualHosts."cache.lorea.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8060$request_uri";
            extraConfig =
              "proxy_set_header Connection \"upgrade\";"
              + "proxy_set_header Upgrade $http_upgrade;"
              + "proxy_set_header X-Forwarded-For $remote_addr;"
              + "proxy_set_header X-Forwarded-Proto $scheme;"
              + "client_max_body_size 32G;";
          };
        };
      };
    };

    users = {
      users.atticd = {
        enable = true;
        group = "atticd";
        isSystemUser = true;
      };
      groups.atticd = { };
    };

    sops.secrets."hosts/myriorama/attic/token".owner = "atticd";

  };
}
