import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Modules.ControlCenter.Cards
import qs.Commons
import qs.Services
import qs.Widgets

NPanel {
  id: root

  Component.onCompleted: Logger.log(scaling)
  panelKeyboardFocus: true

  panelContent: Item {
    id: content

    property real cardSpacing: Style.marginL * scaling

    // Layout content
    ColumnLayout {
      id: layout
      x: content.cardSpacing
      y: content.cardSpacing
      width: parent.width - (2 * content.cardSpacing)
      spacing: content.cardSpacing


      ProfileCard {
        scaling: root.scaling
        Layout.fillWidth: true
        Layout.preferredHeight: 64 * scaling
      }

    }
  }
}
