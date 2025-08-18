{...}: {
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
}
