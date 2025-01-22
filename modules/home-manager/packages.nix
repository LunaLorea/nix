{
  config,
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = [
    pkgs.jq
    pkgs.usbutils
    pkgs.heroic
    # PDF viewer
    pkgs.sioyek
    # Latex distro
    pkgs.rubber
    pkgs.texliveFull
    pkgs.protonmail-desktop
    
    pkgs.teamspeak_client

    pkgs.obs-studio

    # Emoji Picker
    pkgs.smile

    pkgs.modrinth-app
    
    pkgs.krita
  ];
}
