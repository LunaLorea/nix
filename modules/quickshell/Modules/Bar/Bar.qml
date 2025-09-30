import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "Widgets"
import qs.Widgets
import qs.Services


PanelWindow {
  id: root
  anchors {
    bottom: (Settings.barPosition == "bottom")
    top: (Settings.barPosition == "top")
    left: true
    right: true
  }

  implicitHeight: Style.barHeight
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
        color: Qt.alpha(Colors.mSurface, Settings.backgroundOpacity)
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

          Clock {}
          Bluetooth{}
        }

        // middle section
        RowLayout {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          
          spacing: Style.marginS


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
          anchors.verticalCenter: parent.verticalCenter
          anchors.right: parent.right
          anchors.rightMargin: Style.marginM
          
          spacing: Style.marginS


          ControlCenter {}
          
        }
      }
    }
  }
}
