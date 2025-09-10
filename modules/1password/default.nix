{
  host,
  lib,
  config,
  ...
}: {
  options.modules._1password = {
    enable = lib.mkEnableOption "the 1Password module";
  };

  config = lib.mkIf config.modules._1password.enable {
    # Enable 1Password (Needs to be part of NixOS instead of Home Manager to allow for complete functionality)
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = ["host.userName"];
    };
  };
}
