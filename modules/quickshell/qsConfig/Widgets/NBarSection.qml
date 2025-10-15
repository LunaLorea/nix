import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services

import qs.Modules.Bar.Widgets
import qs.Modules.Bar

Rectangle {

  property string position: "middle"
  property ShellScreen screen


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
    spacing: Style.marginS

    anchors {
      left: parent.left
      leftMargin: Style.marginM
      verticalCenter: parent.verticalCenter
    }

    Repeater {

      // Loading Widgets from Settings
      model: ScalingService.getScreenBarWidgets(root.modelData, position)

      delegate: BarWidgetLoader {
        widgetId: (modelData !== undefined ? modelData : "")
        widgetProps: {
          "screen": root.modelData || null,
          "scaling": ScalingService.getScreenScale(root.modelData),
          "widgetId": modelData.id,
        }
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }
}
