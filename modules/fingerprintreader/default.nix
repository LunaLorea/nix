{
  config,
  lib,
  ...
}: {
  
  options.modules.fingerprintreader = {
    enable = lib.mkEnableOption "the fingerprintreader module";
  };

  config = lib.mkIf config.modules.fingerprintreader.enable {
    # Enabling Fingerprint reader
    services.fprintd = {
      enable = true;
    };

    # Enable swaylock to use the fingerprint reader
    security.pam.services = {
      "swaylock" = {
        fprintAuth = true;
      };
    };
  };
}
