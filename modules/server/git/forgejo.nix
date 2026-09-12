{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.server.git.forgejo;
in
{
  options.modules.server.git.forgejo = {
    enable = lib.mkEnableOption "forgejo";
  };
  config = lib.mkIf cfg.enable {
    services = {
      forgejo = {
        enable = true;
        useWizard = false;

        database = {
          type = "postgres";
          createDatabase = true;
        };

        lfs = {
          enable = true;
          contentDir = "/mnt/pool/forgejo/lfs";
        };

        settings = {

          oauth2_client = {
            USERNAME = "nickname";
            ENABLE_AUTO_REGISTRATION = true;
            REGISTER_EMAIL_CONFIRM = false;
            OPENID_CONNECT_SCOPES = "email profile groups";
            ACCOUNT_LINKING = "login";
          };

          server = {
            LANDING_PAGE = "explore";
            DOMAIN = "git.lorea.dev";
            ROOT_URL = "https://git.lorea.dev/";
            HTTP_ADDR = "127.0.0.1";
            HTTP_PORT = 8300;

            # SSH support
            DISABLE_SSH = false;
            START_SSH_SERVER = true;
            SSH_DOMAIN = "git.lorea.dev";
            BUILTIN_SSH_SERVER_USER = "git";
            SSH_PORT = 23;
            SSH_EXPOSE_ANONYMOUS = false;
          };

          ui = {
            SHOW_USER_EMAIL = false;
            DEFAULT_SHOW_FULL_NAME = false;
          };

          session = {
            COOKIE_SECURE = true;
            PROVIDER = "db";
            PROVIDER_CONFIG = "";
            SESSION_LIFE_TIME = 86400 * 5;
          };

          service = {
            DISABLE_REGISTRATION = false;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
            SHOW_REGISTRATION_BUTTON = false;
            ENABLE_INTERNAL_SIGNIN = false;
            ENABLE_NOTIFY_EMAIL = false;
            DEFAULT_KEEP_EMAIL_PRIVATE = true;
            WHITELISTED_URIS = "";
          };

          cache = {
            ADAPTER = "redis";
            HOST = "network=unix,addr=${config.services.redis.servers.forgejo.unixSocket},db=1";
            ITEM_TTL = "72h";
          };

          "service.explore" = {
            DISABLE_USERS_PAGE = true;
          };

          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://git.lorea.dev";
          };
          # Sending emails is completely optional
          # You can send a test email from the web UI at:
          # Profile Picture > Site Administration > Configuration >  Mailer Configuration
          mailer = {
            ENABLED = true;
            SMTP_ADDR = "smtp.eu.mailgun.org";
            SMTP_PORT = 465;
            FROM = "git@mail.wuffli.art";
            USER = "git@mail.wuffli.art";
            PASSWD_URI = "file:/run/secrets/hosts/myriorama/git/forgejo/smtp_pw";

          };

          federation = {
            ENABLED = true;
            MAX_SIZE = 16;
          };

          # NOT actually oidc
          openid = {
            ENABLE_OPENID_SIGNIN = false;
            ENABLE_OPENID_SIGNUP = true;
            WHITELISTED_URIS = "auth.wuffli.art";
          };
        };
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts."git.lorea.dev" = {
          forceSSL = true;
          enableACME = true;
          extraConfig = ''
            access_log syslog:server=unix:/dev/log;
            error_log stderr;
            error_log /var/log/nginx/error.log debug;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:8300";
          };
        };
      };

      redis.servers.forgejo = {
        enable = true;
        user = config.services.forgejo.user;
        save = [ ];
        openFirewall = true;
      };
    };

    systemd.services.forgejo = {
      serviceConfig = {
        # Allow binding to port below 1024, for ssh
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        # Allow using git user
        PrivateUsers = lib.mkForce false;
      };

      # Prevent race conditions with sshd in case of misconfiguration
      wants = [
        "sshd.service"
        "postgresql.service"
        "kanidm.service"
        "redis-forgejo.service"
      ];
      after = [
        "sshd.service"
        "postgresql.service"
        "kanidm.service"
        "redis-forgejo.service"
      ];
    };

    users.users.git = {
      isSystemUser = true;
      group = config.users.groups.git.name;
      extraGroups = [ "forgejo" ];
      createHome = false;
    };

    users.groups.git = { };

    networking.firewall.allowedTCPPorts = [
      23
      8300
    ];

    environment.systemPackages = [
      # For CLI management
      config.services.forgejo.package
    ];

    sops.secrets = {
      "hosts/myriorama/git/forgejo/smtp_pw".owner = "forgejo";
      "hosts/myriorama/git/forgejo/admin_pw".owner = "forgejo";
      "hosts/myriorama/git/forgejo/oidc_client_secret/authelia".owner = "authelia-wuffli";
      "hosts/myriorama/git/forgejo/oidc_client_id".owner = "authelia-wuffli";
    };
  };
}
