{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.server.git.runner;
in
{
  options.modules.server.git.runner = {
    enable = lib.mkEnableOption "forgejo runner";
  };
  config = lib.mkIf cfg.enable {
    services.forgejo-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        secrets.server.connections = {
          default = {
            token_url = "/run/secrets/hosts/myriorama/git/runner/token";
          };
        };
        settings = {
          server.connections = {
            default = {
              url = "https://git.lorea.dev/";
              uuid = "5f5847bc-0498-4325-8b2d-cb955d283419";
            };
          };
          runner.labels = [
            "docker:docker://node:24-alpine"
            "alpine-latest:docker://node:24-alpine"
          ];
        };
      };
    };
    virtualisation.podman = {
      enable = true;
      dockerCompat = true; # Creates a symlink from docker to podman
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };

    users = {
      users.forgejo-runner = {
        enable = true;
        group = "forgejo-runner";
        isSystemUser = true;

        extraGroups = [
          "podman"
        ];
      };
      groups.forgejo-runner = { };
    };

    systemd.services.forgejo-runner-default.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "forgejo-runner";
    };
    sops.secrets."hosts/myriorama/git/runner/token".owner = "forgejo-runner";
  };
}
