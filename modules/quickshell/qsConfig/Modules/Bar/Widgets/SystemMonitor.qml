import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Rectangle {
  id: root

  property ShellScreen screen
  property real scaling
  property real iconSize: Math.max(Style.baseWidgetSize * 0.35 * scaling, 1)
  property real textSize: Math.max(Style.baseWidgetSize * 0.3 * scaling, 1)

  readonly property int percentTextWidth: Math.ceil(percentMetrics.boundingRect.width + 7)
  readonly property int tempTextWidth: Math.ceil(tempMetrics.boundingRect.width + 8)
  readonly property int memTextWidth: Math.ceil(memMetrics.boundingRect.width + 8)

  TextMetrics {
    id: percentMetrics
    font.weight: Style.fontWeightMedium
    font.pointSize: textSize
    text: "99%" // Use the longest possible string for measurement
  }

  TextMetrics {
    id: tempMetrics
    font.weight: Style.fontWeightMedium
    font.pointSize: textSize
    text: "99°" // Use the longest possible string for measurement
  }

  TextMetrics {
    id: memMetrics
    font.weight: Style.fontWeightMedium
    font.pointSize: textSize
    text: "99.9K" // Longest value part of network speed
  }

  anchors.centerIn: parent
  implicitWidth: Math.round(mainRow.implicitWidth + Style.marginM * 2)
  implicitHeight: Style.capsuleHeight
  radius: Style.radiusM
  color: Settings.bar.capsule ? Colors.mSurfaceVariant : Colors.transparent

  RowLayout {
    id: mainRow
    anchors.centerIn: parent
    spacing: Style.marginM

    RowLayout {
      id: cpuUsageContent
      Layout.preferredWidth: childrenRect.width
      Layout.preferredHeight: childrenRect.height
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
        Layout.preferredWidth: percentTextWidth
      }
    }
    RowLayout {
      id: cpuTempContent
      Layout.preferredWidth: childrenRect.width
      Layout.preferredHeight: childrenRect.height
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
        Layout.preferredWidth: tempTextWidth
      }
    }
    RowLayout {
      id: memoryContent
      Layout.preferredWidth: childrenRect.width
      Layout.preferredHeight: childrenRect.height
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
        Layout.preferredWidth: percentTextWidth
      }
    }
    RowLayout {
      id: downloadContent
      Layout.preferredWidth: childrenRect.width
      Layout.preferredHeight: childrenRect.height
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
      Layout.preferredWidth: childrenRect.width
      Layout.preferredHeight: childrenRect.height
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
      Layout.preferredWidth: childrenRect.width
      Layout.preferredHeight: childrenRect.height
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
        Layout.preferredWidth: percentTextWidth
      }
    }
  }
}
