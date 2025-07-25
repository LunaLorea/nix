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

    pkgs.krita
  ];
  programs.ncspot = {
    enable = true;
    settings = {
      shuffle = true;
      gapless = true;
      use_nerdfont = true;
      repeat = "playlist";
      background = "colors.base";
      primary = "colors.text";
      secondary = "colors.subtext1";
      title = "colors.peach";
      playing = "colors.green";
      playing_selected = "colors.teal";
      playing_bg = "colors.base";
      highlight = "colors.sapphire";
      highlight_bg = "colors.base";
      error = "colors.text";
      error_bg = "colors.red";
      statusbar = "colors.overlay2";
      statusbar_progress = "colors.sky";
      statusbar_bg = "colors.sky";
      cmdline = "colors.base";
      cmdline_bg = "colors.text";
    };
  };
}
