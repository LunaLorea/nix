{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.server.git.renovate;
in
{
  options.modules.server.git.renovate = {
    enable = lib.mkEnableOption "renovate bot";
  };
  config = lib.mkIf cfg.enable {
    services = {
      renovate = {
        enable = true;
        credentials = {
          RENOVATE_TOKEN = config.sops.secrets."hosts/myriorama/git/renovate/forgejo_token".path;
          RENOVATE_GITHUB_COM_TOKEN = config.sops.secrets."hosts/myriorama/git/renovate/github_token".path;
        };
        settings = {
          endpoint = "https://git.lorea.dev/api/v1/";
          gitAuthor = "Renovate <renovate@lorea.dev>";
          platform = "forgejo";
          onboardingConfig = {
            extends = [
              "config:recommended"
            ];
          };
          repositories = [
            "luna/nix"
          ];
          nix = {
            enabled = true;
          };
        };
        schedule = "*-*-* *:00:00";
      };
    };
    sops.secrets."hosts/myriorama/git/renovate/forgejo_token" = { };
    sops.secrets."hosts/myriorama/git/renovate/github_token" = { };
  };
}
