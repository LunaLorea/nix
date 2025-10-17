import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services

import qs.Modules.Bar.Widgets
import qs.Modules.Bar

Rectangle {
  id: root

  property string position: "middle"
  property ShellScreen screen
  property real scaling: ScalingService.getScreenScale(screen)


  color: (childrenRect.width > 0) ? Colors.mSurface : Colors.transparent
  radius: Style.radiusXXS

  implicitWidth: childrenRect.width + Style.marginM * 2
  implicitHeight: Style.barHeight * scaling


  anchors {
    left: (position == "left") ? parent.left : undefined
    right: (position == "right") ? parent.right : undefined
    horizontalCenter: (position == "middle") ? parent.horizontalCenter : undefined
  }

  // Widgets
  RowLayout {
    spacing: Style.marginS * scaling

    anchors {
      left: parent.left
      leftMargin: Style.marginM
      verticalCenter: parent.verticalCenter
    }

    Repeater {

      // Loading Widgets from Settings
      model: ScalingService.getScreenBarWidgets(root.screen, position)

      delegate: RowLayout {
        spacing: Style.marginS * scaling
        Rectangle {
          anchors.rightMargin: Style.marginS * scaling
          visible: (model.index > 0)
          width: 2
          height: Style.capsuleHeight * scaling
          color: Colors.mOutline
        }
        BarWidgetLoader {
          widgetId: (modelData !== undefined ? modelData : "")
          widgetProps: {
            "screen": root.screen || null,
            "scaling": root.scaling,
          }
          Layout.alignment: Qt.AlignHCenter
        }
      }
    }
  }
}
