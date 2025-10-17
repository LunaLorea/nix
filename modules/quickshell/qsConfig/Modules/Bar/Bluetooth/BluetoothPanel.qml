import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

NPanel {
  id: root

  preferredWidth: 400 * Math.sqrt(scaling)
  preferredHeight: 500 * Math.sqrt(scaling)
  panelKeyboardFocus: true
  scaling: 1

  panelContent: Rectangle {
    color: Colors.transparent

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginL * scaling
      spacing: Style.marginM * scaling

      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginM * scaling

        NIcon {
          icon: "bluetooth-on"
          font.pointSize: Style.fontSizeXXL * scaling
          color: Colors.mPrimary
        }

        NText {
          text: "Bluetooth"
          font.pointSize: Style.fontSizeL * scaling
          font.weight: Style.fontWeightBold
          color: Colors.mOnSurface
          Layout.fillWidth: true
        }

        NToggle {
          id: bluetoothSwitch
          checked: BluetoothService.enabled
          onToggled: checked => BluetoothService.setBluetoothEnabled(checked)
          baseSize: Style.baseWidgetSize * 0.65 * scaling
        }

        NIconButton {
          enabled: BluetoothService.enabled
          icon: BluetoothService.adapter && BluetoothService.adapter.discovering ? "stop" : "refresh"
          tooltipText: "Refresh devices"
          baseSize: Style.baseWidgetSize * 0.8
          onClicked: {
            if (BluetoothService.adapter) {
              BluetoothService.adapter.discovering = !BluetoothService.adapter.discovering
            }
          }
        }
        NIconButton {
          icon: "close"
          tooltipText: "close Panel"
          baseSize: Style.baseWidgetSize * 0.8
          onClicked: {
            root.close()
          }
        }
      }
      
      NDivider {
        Layout.fillWidth: true
      }

      Rectangle {
        visible: !(BluetoothService.adapter && BluetoothService.adapter.enabled)
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Colors.transparent

        // Center the content within this rectangle
        ColumnLayout {
          anchors.centerIn: parent
          spacing: Style.marginM * scaling

          NIcon {
            icon: "bluetooth-off"
            font.pointSize: 64 * scaling
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: "Bluetooth is disabled"
            font.pointSize: Style.fontSizeL * scaling
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: "Enable Bluetooth to see available Devices"
            font.pointSize: Style.fontSizeS * scaling
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }
        }

      }

      NScrollView {
        visible: BluetoothService.adapter && BluetoothService.adapter.enabled
        Layout.fillWidth: true
        Layout.fillHeight: true

        horizontalPolicy: ScrollBar.AlwaysOff
        verticalPolicy: ScrollBar.AsNeeded
        clip: true
        contentWidth: availableWidth

        ColumnLayout {
          width: parent.width
          spacing: Style.marginM * scaling

          // Connected devices
          BluetoothDevicesList {
            label: "Connected devices"
            property var items: {
              if (!BluetoothService.adapter || !Bluetooth.devices)
                return []
              var filtered = Bluetooth.devices.values.filter(dev => dev && !dev.blocked && dev.connected)
              return BluetoothService.sortDevices(filtered)
            }
            model: items
            visible: items.length > 0
            Layout.fillWidth: true
          }

          // Known devices
          BluetoothDevicesList {
            label: "Known devices"
            tooltipText: "Left click to connect. Right click to forget."
            property var items: {
              if (!BluetoothService.adapter || !Bluetooth.devices)
                return []
              var filtered = Bluetooth.devices.values.filter(dev => dev && !dev.blocked && !dev.connected && (dev.paired || dev.trusted))
              return BluetoothService.sortDevices(filtered)
            }
            model: items
            visible: items.length > 0
            Layout.fillWidth: true
          }

          // Available devices
          BluetoothDevicesList {
            label: "Available devices"
            property var items: {
              if (!BluetoothService.adapter || !Bluetooth.devices)
                return []
              var filtered = Bluetooth.devices.values.filter(dev => dev && !dev.blocked && !dev.paired && !dev.trusted)
              return BluetoothService.sortDevices(filtered)
            }
            model: items
            visible: items.length > 0
            Layout.fillWidth: true
          }

          // Fallback - No devices, scanning
          ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Style.marginM * scaling
            visible: {
              if (!BluetoothService.adapter || !BluetoothService.adapter.discovering || !Bluetooth.devices) {
                return false
              }

              var availableCount = Bluetooth.devices.values.filter(dev => {
                                                                     return dev && !dev.paired && !dev.pairing && !dev.blocked && (dev.signalStrength === undefined || dev.signalStrength > 0)
                                                                   }).length
              return (availableCount === 0)
            }

            RowLayout {
              Layout.alignment: Qt.AlignHCenter
              spacing: Style.marginXS * scaling

              NIcon {
                icon: "refresh"
                font.pointSize: Style.fontSizeXXL * 1.5 * scaling
                color: Colors.mPrimary

                RotationAnimation on rotation {
                  running: true
                  loops: Animation.Infinite
                  from: 0
                  to: 360
                  duration: Style.animationSlow * 4
                }
              }

              NText {
                text: "Scanning for devices..."
                font.pointSize: Style.fontSizeL * scaling
                color: Colors.mOnSurface
              }
            }

            NText {
              text: "Make sure your device is in pairing mode."
              font.pointSize: Style.fontSizeM * scaling
              color: Colors.mOnSurfaceVariant
              Layout.alignment: Qt.AlignHCenter
            }
          }

          Item {
            Layout.fillHeight: true
          }
        }
      }
    }
  }
}
