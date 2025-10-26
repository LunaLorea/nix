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

  implicitWidth: widgets.width + Style.marginM * 2 * scaling
  implicitHeight: Style.barHeight * scaling


  anchors {
    left: (position == "left") ? parent.left : undefined
    right: (position == "right") ? parent.right : undefined
    horizontalCenter: (position == "middle") ? parent.horizontalCenter : undefined
  }

  // Widgets
  RowLayout {
    id: widgets
    //spacing: Style.marginS * scaling

    anchors {
      centerIn: parent
    }

    Repeater {

      // Loading Widgets from Settings
      model: ScalingService.getScreenBarWidgets(root.screen, position)

      delegate: RowLayout {
        spacing: Style.marginS * scaling
        Rectangle {
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
