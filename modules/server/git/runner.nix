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
    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        name = "myriorama";
        url = "https://codeberg.org";
        # Obtaining the path to the runner token file may differ
        # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
        tokenFile = "/run/secrets/hosts/myriorama/git/runner/token";
        labels = [
          "docker:docker://node:24-alpine"
          "alpine-latest:docker://node:24-alpine"
        ];
      };
    };
    virtualisation.podman = {
      enable = true;
      dockerCompat = true; # Creates a symlink from docker to podman
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };

    users = {
      users.gitea-runner = {
        enable = true;
        group = "gitea-runner";
        isSystemUser = true;

        extraGroups = [
          "podman"
        ];
      };
      groups.gitea-runner = { };
    };

    systemd.services.gitea-runner-default.serviceConfig.DynamicUser = lib.mkForce false;
    sops.secrets."hosts/myriorama/git/runner/token".owner = "gitea-runner";
  };
}
