{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.mastodon;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.mastodon = {
    enable = mkEnableOption "mastodon service";
  };

  config = mkIf cfg.enable {
    services.mastodon = {
      enable = true;
      localDomain = "social.lorea.dev"; # Replace with your own domain
      configureNginx = true;
      smtp.fromAddress = "noreply@lorea.dev"; # Email address used by Mastodon to send emails, replace with your own
      extraConfig.SINGLE_USER_MODE = "true";
      streamingProcesses = 3; # Number of processes used by the mastodon-streaming service. recommended is the amount of your CPU cores minus one.
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
