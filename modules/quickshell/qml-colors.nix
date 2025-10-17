{
  colors,
  pkgs,
  ...
}: let
  qml-file = pkgs.writeTextFile {
    name = "Colors.qml";
    text = ''
      pragma Singleton

      import Quickshell
      import QtQuick

      Singleton {
        id: root

        // --- Key Colors:
        property color mPrimary: "${colors.Primary}"
        property color mOnPrimary: "${colors.OnPrimary}"

        property color mSecondary: "${colors.Secondary}"
        property color mOnSecondary: "${colors.OnSecondary}"

        property color mTertiary: "${colors.Tertiary}"
        property color mOnTertiary: "${colors.OnTertiary}"


        // --- Utility Colors:
        property color mError: "${colors.Error}"
        property color mOnError: "${colors.OnError}"

        property color mWarning: "${colors.Warning}"
        property color mOnWarning: "${colors.OnWarning}"

        property color mGreen: "${colors.teal}"


        // --- Surface Colors:
        property color mSurface: "${colors.Surface}"
        property color mOnSurface: "${colors.OnSurface}"

        property color mSurfaceVariant: "${colors.SurfaceVariant}"
        property color mOnSurfaceVariant: "${colors.OnSurfaceVariant}"

        property color mOutline: "${colors.Outline}"
        property color mShadow: "${colors.Shadow}"

        property color transparent: "transparent"
      }
    '';
  };
in {
  home.file.colors-qml-dev = {
    enable = true;
    source = qml-file;
    target = "./.config/nix/modules/quickshell/qsConfig/Commons/Colors.qml";
  };
  xdg.configFile.colors-qml = {
    enable = false;
    source = qml-file;
    target = "./.config/quickshell/Commons/Colors.qml";
  };
}
