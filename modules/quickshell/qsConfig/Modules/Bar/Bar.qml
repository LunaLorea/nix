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


      implicitHeight: Style.barHeight * scaling
      color: Colors.transparent

      Loader {
        id: barLoader

        anchors.fill: parent

        sourceComponent: Item {
          anchors.fill: parent
          clip: true
          Rectangle {
            id: bar
            anchors.fill: parent
            color: Qt.alpha(Colors.mSurface, Settings.bar.backgroundOpacity)
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
          }



          Item {
            anchors.fill: parent

            // left section
            RowLayout {
              anchors.verticalCenter: parent.verticalCenter
              anchors.left: parent.left
              anchors.leftMargin: Style.marginM

              spacing: Style.marginS

              Repeater {
                model: ScalingService.getScreenBarWidgets(root.modelData, "left")
                delegate: BarWidgetLoader {
                  widgetId: (modelData !== undefined ? modelData : "")
                  widgetProps: {
                    "screen": root.modelData || null,
                    "scaling": ScalingService.getScreenScale(screen),
                    "widgetId": modelData.id,
                  }
                  Layout.alignment: Qt.AlignHCenter
                }
              }
            }

            // middle section
            RowLayout {
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.verticalCenter: parent.verticalCenter

              spacing: Style.marginS

              Repeater {
                model: ScalingService.getScreenBarWidgets(root.modelData, "middle")
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
              Repeater {
                model: 6
                delegate: Rectangle {
                  id: top
                  color: Colors.mPrimary
                  implicitWidth: 20
                  implicitHeight: 20
                }
              }
            }

            // right section
            RowLayout {
              id: test
              anchors.verticalCenter: parent.verticalCenter
              anchors.right: parent.right
              anchors.rightMargin: Style.marginM

              spacing: Style.marginS


              Repeater {
                model: ScalingService.getScreenBarWidgets(root.modelData, "right")
                delegate: BarWidgetLoader {
                  widgetId: (modelData !== undefined ? modelData : "")
                  widgetProps: {
                    "screen": root.modelData || null,
                    "scaling": ScalingService.getScreenScale(screen),
                    "widgetId": modelData.id,
                  }
                  Layout.alignment: Qt.AlignHCenter
                }
              }
            }
          }
        }
      }
    }
  }
}
