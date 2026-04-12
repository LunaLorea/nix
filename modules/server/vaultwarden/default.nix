{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.vaultwarden;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.vaultwarden = {
    enable = mkEnableOption "ssh server";
  };
  config = mkIf cfg.enable {
    services = {
      vaultwarden = {
        enable = true;
        backupDir = "/var/local/vaultwarden/backup";
        config = {
          DOMAIN = "https://vaultwarden.wuffli.art";
          SIGNUPS_ALLOWED = false;

          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          ROCKET_LOG = "critical";
        };
      };
    };
  };
}
