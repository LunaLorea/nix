import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects
import qs.Commons
import qs.Widgets
import qs.Services

NIconButton {
  id: root

  property ShellScreen screen
  property real scaling: 1.0

  tooltipText: "Open Control Center"
  baseSize: Style.capsuleHeight * scaling
  colorBg: Colors.mSurfaceVariant
  colorFg: Colors.mOnSurface
  icon: "nix"
  onClicked: PanelService.getPanel("controlCenterPanel")?.toggle(this)
  onRightClicked: PanelService.getPanel("controlCenterPanel")?.toggle(this)

  //Widget Properties
  //
}
