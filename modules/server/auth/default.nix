{
  lib,
  config,
  ...
}: let
  inherit (lib) mkAfter mkIf mkEnableOption;
  cfg = config.modules.server.auth;
in {
  options.modules.server.auth = {
    enable = mkEnableOption "auth service";
  };
  config = mkIf cfg.enable {
    users = {
      users."authelia-wuffli" = {
        extraGroups = ["redis-wuffli"];
      };
    };
    users = {
      users.lldap = {
        group = "lldap";
        isSystemUser = true;
      };
      groups.lldap = {};
    };
    services = {
      redis.servers.wuffli.enable = true;
      lldap = {
        enable = true;
        settings = {
          ldap_user_pass_file = "/run/secrets/hosts/myriorama/lldap/admin_default_pw";
          ldap_user_email = "lldap@lunalorea.ch";
          ldap_user_dn = "admin";
          ldap_base_dn = "dc=ldap,dc=wuffli,dc=art";
          ldap_host = "0.0.0.0";
          http_host = "0.0.0.0";
          http_port = 8043;
          jwt_secret_file = "/run/secrets/hosts/myriorama/lldap/jwt_secret";
          database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
        };
      };
      postgresql = {
        enable = true;
        ensureDatabases = [
          "authelia-wuffli"
          "lldap"
        ];
        ensureUsers = [
          {
            name = "authelia-wuffli";
            ensureDBOwnership = true;
          }
          {
            name = "lldap";
            ensureDBOwnership = true;
          }
        ];
        extensions = ps: [
          ps.pgvector
          ps.vectorchord
        ];
        settings = {
          shared_preload_libraries = ["vchord.so"];
          search_path = "\"$user\", public, vectors";
        };
      };
      authelia.instances.wuffli = {
        enable = true;
        settings = {
          theme = "dark";
          authentication_backend.ldap = {
            address = "ldap://localhost:3890";
            base_dn = "dc=ldap,dc=wuffli,dc=art";
            users_filter = "(&({username_attribute}={input})(objectClass=person))";
            groups_filter = "(member={dn})";
            user = "uid=authelia,ou=people,dc=ldap,dc=wuffli,dc=art";
          };
          access_control = {
            default_policy = "deny";
            # We want this rule to be low priority so it doesn't override the others
            rules = mkAfter [
              {
                domain = "*.wuffli.art";
                policy = "one_factor";
              }
            ];
          };
          storage.postgres = {
            address = "unix:///run/postgresql";
            database = "authelia-wuffli";
            username = "authelia-wuffli";
          };
          session = {
            redis.host = "/var/run/redis-wuffli/redis.sock";
            cookies = [
              {
                domain = "wuffli.art";
                authelia_url = "https://auth.wuffli.art";
                # The period of time the user can be inactive for before the session is destroyed
                inactivity = "1M";
                # The period of time before the cookie expires and the session is destroyed
                expiration = "3M";
                # The period of time before the cookie expires and the session is destroyed
                # when the remember me box is checked
                remember_me = "1y";
              }
            ];
          };
          notifier.smtp = {
            address = "smtp://smtp.eu.mailgun.org:587";
            username = "authentication@mail.wuffli.art";
            sender = "authentication@mail.wuffli.art";
          };
          log.level = "info";
          identity_providers.oidc = {
            claims_policies = {
            };
            cors = {
              endpoints = ["token"];
              allowed_origins_from_client_redirect_uris = true;
            };
            authorization_policies.default = {
              default_policy = "one_factor";
              rules = [
                {
                  policy = "deny";
                  subject = "group:lldap_strict_readonly";
                }
              ];
            };
          };
          webauthn = {
            enable_passkey_login = true;
          };
          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };
        # Templates don't work correctly when parsed from Nix, so our OIDC clients are defined here
        settingsFiles = [./oidc_clients.yaml];
        secrets = let
          directory = "/run/secrets/hosts/myriorama/authelia";
        in {
          jwtSecretFile = "${directory}/jwt_secret";
          oidcIssuerPrivateKeyFile = "${directory}/jwks_secret";
          oidcHmacSecretFile = "${directory}/hmac_secret";
          sessionSecretFile = "${directory}/session_secret";
          storageEncryptionKeyFile = "${directory}/storage_encryption_key";
        };
        environmentVariables = {
          AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = "/run/secrets/hosts/myriorama/authelia/lldap_pw";
          AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = "/run/secrets/hosts/myriorama/authelia/smtp_pw";
        };
      };
    };
    sops.secrets = {
      "hosts/myriorama/authelia/jwt_secret".owner = "authelia-wuffli";
      "hosts/myriorama/authelia/jwks_secret".owner = "authelia-wuffli";
      "hosts/myriorama/authelia/hmac_secret".owner = "authelia-wuffli";
      "hosts/myriorama/authelia/session_secret".owner = "authelia-wuffli";
      "hosts/myriorama/authelia/storage_encryption_key".owner = "authelia-wuffli";
      "hosts/myriorama/authelia/lldap_pw".owner = "authelia-wuffli";
      "hosts/myriorama/authelia/smtp_pw".owner = "authelia-wuffli";
      "hosts/myriorama/audiobookshelf/oidc_client_secret/authelia".owner = "authelia-wuffli";
      "hosts/myriorama/audiobookshelf/oidc_client_id".owner = "authelia-wuffli";
      "hosts/myriorama/vaultwarden/oidc_client_secret/authelia".owner = "authelia-wuffli";
      "hosts/myriorama/vaultwarden/oidc_client_id".owner = "authelia-wuffli";
      "hosts/myriorama/jellyfin/oidc_client_secret/authelia".owner = "authelia-wuffli";
      "hosts/myriorama/jellyfin/oidc_client_id".owner = "authelia-wuffli";
      "hosts/myriorama/lldap/admin_default_pw".owner = "lldap";
      "hosts/myriorama/lldap/jwt_secret".owner = "lldap";
    };
  };
}
