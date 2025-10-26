import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Rectangle {
  id: root

  property real scaling
  property real iconSize: Math.max(Style.baseWidgetSize * 0.35 * scaling, 1)
  property real textSize: Math.max(Style.baseWidgetSize * 0.3 * scaling, 1)

  anchors.centerIn: parent
  implicitWidth: Math.round(mainRow.implicitWidth + Style.marginM * 2)
  implicitHeight: Style.capsuleHeight
  radius: Style.radiusM
  color: Settings.bar.capsule ? Colors.mSurfaceVariant : Colors.transparent

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    onClicked: Quickshell.execDetached(["floating", "kitty", "btm"])
    acceptedButtons: Qt.LeftButton
    cursorShape: Qt.PointingHandCursor
  }

  RowLayout {
    id: mainRow
    anchors.centerIn: parent
    spacing: Style.marginM * scaling

    RowLayout {
      id: cpuUsageContent
      Layout.alignment: Qt.AlignVCenter

      NIcon {
        icon: "cpu-usage"
        Layout.alignment: Qt.AlignCenter
        font.pointSize: iconSize
      }
      NText {
        text: `${Math.round(SystemStatService.cpuUsage)}%`
        font.weight: Style.fontWeightMedium
        font.pointSize: textSize
        Layout.alignment: Qt.AlignCenter
      }
    }
    RowLayout {
      id: cpuTempContent
      Layout.alignment: Qt.AlignVCenter

      NIcon {
        icon: "cpu-temp"
        Layout.alignment: Qt.AlignCenter
        font.pointSize: iconSize
      }
      NText {
        text: `${Math.round(SystemStatService.cpuTemp)}°`
        font.weight: Style.fontWeightMedium
        font.pointSize: textSize
        Layout.alignment: Qt.AlignCenter
      }
    }
    RowLayout {
      id: memoryContent
      Layout.alignment: Qt.AlignVCenter

      NIcon {
        icon: "memory"
        Layout.alignment: Qt.AlignCenter
        font.pointSize: iconSize
      }
      NText {
        text: `${Math.round(SystemStatService.memPercent)}%`
        font.weight: Style.fontWeightMedium
        font.pointSize: textSize
        Layout.alignment: Qt.AlignCenter
      }
    }
    RowLayout {
      id: downloadContent
      Layout.alignment: Qt.AlignVCenter

      NIcon {
        icon: "download-speed"
        Layout.alignment: Qt.AlignCenter
        font.pointSize: iconSize
      }
      NText {
        text: SystemStatService.formatSpeed(SystemStatService.rxSpeed)
        font.weight: Style.fontWeightMedium
        font.pointSize: textSize
        Layout.alignment: Qt.AlignCenter
      }
    }
    RowLayout {
      id: uploadContent
      Layout.alignment: Qt.AlignVCenter

      NIcon {
        icon: "upload-speed"
        Layout.alignment: Qt.AlignCenter
        font.pointSize: iconSize
      }
      NText {
        text: SystemStatService.formatSpeed(SystemStatService.txSpeed)
        font.weight: Style.fontWeightMedium
        font.pointSize: textSize
        Layout.alignment: Qt.AlignCenter
      }
    }
    RowLayout {
      id: diskUsageContent
      Layout.alignment: Qt.AlignVCenter

      NIcon {
        icon: "storage"
        Layout.alignment: Qt.AlignCenter
        font.pointSize: iconSize
      }
      NText {
        text: `${Math.round(SystemStatService.diskPercent)}%`
        font.weight: Style.fontWeightMedium
        font.pointSize: textSize
        Layout.alignment: Qt.AlignCenter
      }
    }
  }
}
