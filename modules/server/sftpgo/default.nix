{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.server.sftpgo;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.modules.server.sftpgo = {
    enable = mkEnableOption "sftpgo service";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        8090
        2022
      ];
    };
    services = {
      sftpgo = {
        enable = true;
        dataDir = "/mnt/pool/cloud";
        settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./config.json)) {
          data_provider = {
            pre_login_hook = pkgs.writeShellScript "pre_login_hook" ''
                          #!/usr/bin/env sh
              # Create a user on OIDC login if it doesn't exist.
              #
              # https://docs.sftpgo.com/2.6/dynamic-user-mod/

              # Extract fields from user JSON.
              # USER_ID=$(echo "$SFTPGO_LOGIND_USER" | jq -r '.id')
              # USERNAME=$(echo "$SFTPGO_LOGIND_USER" | jq -r '.username')

              USER_ID=$(echo "$SFTPGO_LOGIND_USER" | ${lib.getExe pkgs.gnused} -n 's/.*"id":[[:space:]]*\([0-9]*\).*/\1/p')
              USERNAME=$(echo "$SFTPGO_LOGIND_USER" | ${lib.getExe pkgs.gnused} -n 's/.*"username":[[:space:]]*"\([^"]*\)".*/\1/p')

              # Only proceed if the user doesn't exist.
              [ "$USER_ID" != 0 ] && exit

              # Only proceed if login method is OIDC.
              [ "$SFTPGO_LOGIND_METHOD" != "IDP" ] && exit
              [ "$SFTPGO_LOGIND_PROTOCOL" != "OIDC" ] && exit

              # Write the user to stdout to create the user.
              # https://github.com/drakkan/sftpgo/blob/2.6.x/openapi/openapi.yaml#L5847
              ${lib.getExe pkgs.coreutils} --coreutils-prog=cat <<EOF
              {
                  "status": 1,
                  "username": "$USERNAME",
                  "has_password": false,
                  "permissions": {
                      "/": ["*"]
                  }
              }
              EOF
            '';
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
        virtualHosts."sftpgo.wuffli.art" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://[::1]:9080$request_uri";
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
    sops.secrets = {
      "hosts/myriorama/sftpgo/oidc_client_secret/authelia".owner = "authelia-wuffli";
      "hosts/myriorama/sftpgo/oidc_client_secret/sftpgo".owner = "sftpgo";
      "hosts/myriorama/sftpgo/oidc_client_id".owner = "authelia-wuffli";
    };
  };
}
