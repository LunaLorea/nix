import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services

import qs.Modules.Bar.Widgets
import qs.Modules.Bar

Item {
  id: root

  property string position: "middle"
  property ShellScreen screen
  property real scaling: ScalingService.getScreenScale(screen)


  Rectangle {
    anchors.fill: parent
    opacity: Settings.bar.backgroundOpacity.section
    color: (widgets.width > 0) ? Colors.mSurface : Colors.transparent
    radius: Settings.bar.floating ? Style.radiusXXS : 0
  }

  implicitWidth: widgets.width + (Settings.bar.floating ? (Style.marginM * 2) : 0) * scaling
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
          visible: (model.index > 0) && (Settings.bar.backgroundOpacity.widgetSeparator > 0)
          width: 2
          height: Style.capsuleHeight * scaling
          color: Colors.mOutline
          opacity: Settings.bar.backgroundOpacity.widgetSeparator
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
