{
  lib,
  config,
  ...
}: let
  cfg = config.modules.server.matrix;
in {
  config = lib.mkIf cfg.enable {
    services.mautrix-whatsapp = {
      enable = true;
      settings = {
        network = {
          history_sync = {
            max_initial_conversations = 0;
            request_full_sync = false;
            backwards_on_demand = false;
          };
        };
        backfill = {
          enabled = true;
        };
        bridge = {
          permissions = {
            "@luna:lorea.dev" = "admin";
            "lorea.dev" = "user";
          };
        };
        homeserver = {
          address = "http://127.0.0.1:6167";
          domain = "lorea.dev";
        };
      };
    };

    sops.secrets = {
      "hosts/myriorama/matrix/mautrix-whatsapp".owner = "mautrix-whatsapp";
    };
    nixpkgs.config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };
}
