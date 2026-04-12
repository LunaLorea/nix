{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.openssh;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.modules.server.openssh = {
    enable = mkEnableOption "ssh server";
  };
  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowPing = true;
    };
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["luna"];
      };
    };
  };
}
