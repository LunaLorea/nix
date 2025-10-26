import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Modules.ControlCenter
import qs.Commons
import qs.Services
import qs.Widgets

NBox {
  id: root

  property string uptimeText: "--"
  property real scaling: 1

  RowLayout {
    id: content
    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
      margins: Style.marginM * scaling
    }
    spacing: Style.marginS * scaling

    NText {
      text: Settings.userName + "@" + Settings.hostName
      color: Colors.mOnSurface
      Layout.fillWidth: true
    }


    NIconButton {
      id: shutdown

      property real scaling: 1.0

      tooltipText: "shutdown"
      baseSize: Style.capsuleHeight * scaling
      colorBg: Colors.mSurfaceVariant
      border {
        width: Style.borderS * scaling
        color: Qt.darker(Colors.mOnSurfaceVariant)
      }
      icon: "shutdown"
      onClicked: Quickshell.execDetached(["shutdown", "-h", "now"])
    }
    NIconButton {
      id: reboot

      property real scaling: 1.0

      tooltipText: "reboot"
      baseSize: Style.capsuleHeight * scaling
      colorBg: Colors.mSurfaceVariant
      border {
        width: Style.borderS * scaling
        color: Qt.darker(Colors.mOnSurfaceVariant)
      }
      icon: "reboot"
      onClicked: Quickshell.execDetached(["reboot"])
    }
    NIconButton {
      id:  lock

      property real scaling: 1.0

      tooltipText: "lock with swaylock"
      baseSize: Style.capsuleHeight * scaling
      colorBg: Colors.mSurfaceVariant
      border {
        width: Style.borderS * scaling
        color: Qt.darker(Colors.mOnSurfaceVariant)
      }
      icon: "lock"
      onClicked: function() {
        PanelService.closeAllPanels()
        Quickshell.execDetached(["lock"])
      }
    }
    NIconButton {
      id: hibernate

      property real scaling: 1.0

      tooltipText: "hibernate"
      baseSize: Style.capsuleHeight * scaling
      colorBg: Colors.mSurfaceVariant
      border {
        width: Style.borderS * scaling
        color: Qt.darker(Colors.mOnSurfaceVariant)
      }
      icon: "hibernate"
      onClicked: function() {
        PanelService.closeAllPanels()
        Quickshell.execDetached(["systemctl", "hybrid-sleep" ])
        Quickshell.execDetached(["lock"])
      }
    }
  }
}
