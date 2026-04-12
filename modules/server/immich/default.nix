{
  lib,
  config,
  ...
}: let
  cfg = config.modules.server.immich;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.immich = {
    enable = mkEnableOption "immich service";
  };

  config = mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        ensureDatabases = [
          "immich"
        ];
        ensureUsers = [
          {
            name = "immich";
            ensureDBOwnership = true;
            ensureClauses.login = true;
          }
        ];
      };
      immich = {
        enable = true;
        openFirewall = true;
        host = "192.168.178.26";
        mediaLocation = "/mnt/pool/media/photos";
        environment = {
          IMMICH_CONFIG_FILE = config.sops.templates.immich-config.path;
        };
      };
    };
    sops = {
      templates.immich-config = {
        content =
          # json
          ''
            {
              "backup": {
                "database": {
                  "enabled": false,
                }
              },
              "newVersionCheck": {
                "enabled": false
              },
              "oauth": {
                "enabled": true,
                "clientId": "${config.sops.placeholder.immich-oidc-client-id_immich}",
                "clientSecret": "${config.sops.placeholder."hosts/myriorama/immich/oidc_client_secret/immich"}",
                "issuerUrl": "https://auth.wuffli.art/.well-known/openid-configuration",
                "scope": "openid profile email",
                "tokenEndpointAuthMethod": "client_secret_post",
                "autoLaunch": true,
                "autoRegister": true,
                "defaultStorageQuota": 0,
                "mobileOverrideEnabled": false,
                "mobileRedirectUri": "",
                "profileSigningAlgorithm": "none",
                "signingAlgorithm": "RS256",
                "storageLabelClaim": "preferred_username",
                "storageQuotaClaim": "immich_quota",
                "timeout": 30000,
                "buttonText": "Login with Authelia"
              },
              "passwordLogin": {
                "enabled": false
              },
              "server": {
                "externalDomain": "https://immich.wuffli.art",
              },
            }
          '';
        owner = "immich";
      };
      secrets = {
        immich-oidc-client-id_immich = {
          key = "hosts/myriorama/immich/oidc_client_id";
          owner = "immich";
        };
        "hosts/myriorama/immich/oidc_client_secret/immich".owner = "immich";
        "hosts/myriorama/immich/oidc_client_secret/authelia".owner = "authelia-wuffli";
        "hosts/myriorama/immich/oidc_client_id".owner = "authelia-wuffli";
      };
    };
  };
}
