{
  host,
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.passwordmanager = {
    enable = lib.mkEnableOption "the 1Password module";
  };

  config = lib.mkIf config.modules.passwordmanager.enable {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];
    # Enable 1Password (Needs to be part of NixOS instead of Home Manager to allow for complete functionality)
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ "${host.userName}" ];
    };
  };
}
