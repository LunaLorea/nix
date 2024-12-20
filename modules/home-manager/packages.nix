{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jq
    usbutils
    heroic
    # PDF viewer
    sioyek
    # Latex distro
    rubber
    texliveFull
    protonmail-desktop
    
    teamspeak_client

    obs-studio
  ];
}
