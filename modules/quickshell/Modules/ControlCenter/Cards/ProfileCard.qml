import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Modules.Settings
import qs.Modules.ControlCenter
import qs.Commons
import qs.Services
import qs.Widgets

NBox {
  id: root

  property string uptimeText: "--"

  RowLayout: {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: Style.marginM * scaling
    spacing: Style.marginM * scaling

    NImageCircled {
      width: Style.baseWidgetSize * 1.25 * scaling
      height: Style.baseWidgetSize * 1.25 * scaling
      imagePath: Settings.avatarImage
      borderColor: Colors.mPrimary
      borderWidth: Math.max(1, Style.borderM * scaling)
    }
  }
}
