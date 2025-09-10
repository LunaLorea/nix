{
  pkgs,
  colors,
  ...
}: let
  background-color = colors.base + "dd";

  sway-cs = pkgs.writeText "sway-cs" (builtins.readFile ./cheatsheets/sway-cs);
  nvim-cs = pkgs.writeText "nvim-cs" (builtins.readFile ./cheatsheets/nvim-cs);
  kitty-cs = pkgs.writeText "kitty-cs" (builtins.readFile ./cheatsheets/kitty-cs);

  cheatsheet-css = pkgs.writeText "cheatsheet.css" ''
    window {
      background-color: ${background-color};
      color: ${colors.text};
    }

    #box-outer {
      /* Define attributes of the box surrounding icons here */
      background-color: ${background-color};
      color: ${colors.text};
    }

    #box-inner {
      /* background-color: rgba ((61,76,95, 0.9); */
      /* background-color: rgba (255, 255, 255, 1.0); */
      /* border-width: 4px; */
      /* box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3) 0 15px 12px rgba(0, 0, 0, 0.22); */

      /* border-radius: 8px; */
      /* border-color: rgba (156, 142, 122, 1.0); */
      /* padding: 2px 2px; */
      /* box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22); */
      /* background-color: rgba (23, 53, 63, 0.75); */
      background-color: ${background-color};
      border-radius: 6px;
      margin: 0px 9px 9px 0px;
      padding: 6px;
      /* box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22); */
      box-shadow: 0px 3px 5px black
      color: ${colors.text};
    }
  '';

  nwg-wrap = pkgs.writeShellScriptBin "switch-cheatsheet" ''

    cheatsheetstate="$HOME"/.cheatsheet-is-active

    if ! test -f cheatsheetstate; then
        touch cheatsheetstate
        echo "0" > "$cheatsheetstate"
    fi

    read -r isactive < "$cheatsheetstate"

    if [ "$isactive" -eq "1" ]; then
      pkill -f -2 nwg-wrapper
      echo "0" > "$cheatsheetstate"
    else
      echo "1" > "$cheatsheetstate"
      app=$(${pkgs.sway}/bin/swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .app_id')
      name=$(${pkgs.sway}/bin/swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .name')
      case "$app" in
        "kitty")
          case $name in
            Nvim)
              sheet=${nvim-cs}
              ;;
            *)
              sheet=${kitty-cs}
              ;;
          esac
          ;;
        *)
          sheet=${sway-cs}
          if [ $app == "kitty" ]; then echo kitty match; fi
          if [ "$name" == "Nvim" ]; then echo kitty match; fi
          ;;
      esac
      ${pkgs.nwg-wrapper}/bin/nwg-wrapper -t $sheet -c bindings.css -p right -mr 200 -l 2
    fi
  '';
in {
  home.packages = with pkgs; [
    nwg-wrap
  ];
}
