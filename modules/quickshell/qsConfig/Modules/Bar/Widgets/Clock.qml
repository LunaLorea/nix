import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons
import qs.Services


Rectangle {
  id: root

  readonly property var now: Time.date
  property real scaling: 1.0
  property ShellScreen screen
  property string tooltipText: Qt.formatDateTime(now, "dddd".trim())

  implicitWidth: (loader.width + 2 * (Settings.bar.capsule ? Style.marginM : 0) * scaling)
  implicitHeight: Style.capsuleHeight * scaling

  radius: Style.radiusS * scaling
  color: Settings.bar.capsule ? Colors.mSurfaceVariant : Colors.transparent

  Item {
    id: clockContainer
    anchors.centerIn: parent
    anchors.fill: parent
    
    Loader {
      id: loader

      anchors.centerIn: parent

      sourceComponent: ColumnLayout {
        anchors.centerIn: parent
        spacing: 2

        Repeater {
          id: repeater
          model: Qt.formatDateTime(now, Settings.clockFormat.trim()).split("\\n")
          NText {
            visible: text !== ""
            text: modelData

            font.pointSize: Style.fontSizeM * root.scaling
            font.weight: Style.fontWeightBold
            color: Colors.mOnSurface

            wrapMode: Text.WordWrap
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
          }
        }
      }
    }
  }
  
  Process {
    id: startCalendar
    running: false
    command: [ "firefox", "-p", "calendar", "--name", "Firefox-calendar", "-no-remote"]
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    cursorShape: Qt.PointingHandCursor
    onClicked: function() {
      startCalendar.running = !startCalendar.running
    }
  }

  MouseArea {
    enabled: true
    anchors.fill: parent
    cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    hoverEnabled: true
    onEntered: {
      TooltipService.show(root, root.tooltipText, "auto", 1000)
    }
    onExited: {
      TooltipService.hide()
    }
  }
}
