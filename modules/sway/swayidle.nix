{ 
  pkgs,
  lib,
  colors,
  ...
}:{
  services.swayidle = let
  # Sway
  display = status: "swaymsg output * power ${status}";
  lock = ''
    ${pkgs.swaylock-effects}/bin/swaylock \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 100 \
      --indicator-thickness 7 \
      --effect-blur 7x5 \
      --effect-vignette 0.5:0.5 \
      --fade-in 0\
      --ring-color ${lib.strings.removePrefix "#" colors.peach}\
      -f'';
  in {
    enable = true;
    timeouts = [
    {
      timeout = 30; # in seconds
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds' -t 5000";
    }
  {
      timeout = 60;
      command = lock;
    }
    {
      timeout = 70;
      command = display "off";
      resumeCommand = display "on";
    }
    {
      timeout = 120;
      command = "${pkgs.systemd}/bin/systemctl hybrid-sleep";
    }
    ];
    events = [
    {
      event = "before-sleep";
# adding duplicated entries for the same event may not work
      command = (display "off") + "; " + lock;
    }
    {
      event = "after-resume";
      command = display "on";
    }
    {
      event = "lock";
      command = (display "off") + "; " + lock;
    }
    {
      event = "unlock";
      command = display "on";
    }
    ];
  };
}
