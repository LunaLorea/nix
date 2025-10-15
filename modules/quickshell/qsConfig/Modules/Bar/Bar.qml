import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Modules.Bar.Widgets
import qs.Widgets
import qs.Services

Variants {
  model: Quickshell.screens

  delegate: Loader {
    id: root
    required property ShellScreen modelData
    property real scaling: ScalingService.getScreenScale(modelData)
    property string barPosition: ScalingService.getScreenBarPosition(modelData)

    active: ScalingService.getScreenShowBar(modelData)


    sourceComponent: PanelWindow {
      screen: modelData || null

      anchors {
        bottom: (barPosition == "bottom")
        top: (barPosition == "top")
        left: true
        right: true
      }


      implicitHeight: (Style.barHeight + Style.marginXS) * scaling
      color: Colors.transparent

      Loader {
        id: barLoader

        anchors.fill: parent

        sourceComponent: Item {
          anchors.fill: parent
          clip: true

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
          }

          Rectangle {
            anchors.fill: parent
            color: Colors.mSurface
            opacity: Settings.bar.backgroundOpacity
          }

          // --- Bar Layout
          Item {

            anchors {
              fill: parent
              leftMargin: Settings.bar.floating ? Style.marginS * scaling : 0
              rightMargin: Settings.bar.floating ? Style.marginS * scaling : 0
              topMargin: Settings.bar.floating ? Style.marginXS * scaling : 0
            }
            // Sections
            Repeater {
              model: ["left", "middle", "right"]
              delegate: NBarSection {
                position: modelData
                screen: root.modelData
              }
            }
          }
        }
      }
    }
  }
}
