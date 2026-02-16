{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "git@lunalorea.ch";
        name = "Luna Zehnder";
      };
    };
    signing = {
      signByDefault = true;
      signer = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvuUjUHkdOUt5yK7SwUa6hv/08FdbYsFjJeUbGFx88S";
    };
  };
}
