import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

ColumnLayout {
  id: root

  property string label: ""
  property string tooltipText: ""
  property var model: {

  }

  Layout.fillWidth: true
  spacing: Style.marginM * scaling

  NText {
    text: root.label
    font.pointSize: Style.fontSizeL * scaling
    color: Colors.mSecondary
    font.weight: Style.fontWeightMedium
    Layout.fillWidth: true
    visible: root.model.length > 0
  }

  Repeater {
    id: deviceList
    Layout.fillWidth: true
    model: root.model
    visible: BluetoothService.adapter && BluetoothService.adapter.enabled

    Rectangle {
      id: device

      readonly property bool canConnect: BluetoothService.canConnect(modelData)
      readonly property bool canDisconnect: BluetoothService.canDisconnect(modelData)
      readonly property bool isBusy: BluetoothService.isDeviceBusy(modelData)

      function getContentColor(defaultColor = Colors.mOnSurface) {
        if (modelData.pairing || modelData.state === BluetoothDeviceState.Connecting)
          return Colors.mPrimary
        if (modelData.blocked)
          return Colors.mError
        return defaultColor
      }

      Layout.fillWidth: true
      Layout.preferredHeight: deviceLayout.implicitHeight + (Style.marginM * scaling * 2)
      radius: Style.radiusM * scaling
      color: Colors.mSurface
      border.width: Math.max(1, Style.borderS * scaling)
      border.color: getContentColor(Colors.mOutline)

      RowLayout {
        id: deviceLayout
        anchors.fill: parent
        anchors.margins: Style.marginM * scaling
        spacing: Style.marginM * scaling
        Layout.alignment: Qt.AlignVCenter

        // One device BT icon
        NIcon {
          icon: BluetoothService.getDeviceIcon(modelData)
          font.pointSize: Style.fontSizeXXL * scaling
          color: getContentColor(Colors.mOnSurface)
          Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: Style.marginXXS * scaling

          // Device name
          NText {
            text: modelData.name || modelData.deviceName
            font.pointSize: Style.fontSizeM * scaling
            font.weight: Style.fontWeightMedium
            elide: Text.ElideRight
            color: getContentColor(Colors.mOnSurface)
            Layout.fillWidth: true
          }

          // Status
          NText {
            text: BluetoothService.getStatusString(modelData)
            visible: text !== ""
            font.pointSize: Style.fontSizeXS * scaling
            color: getContentColor(Colors.mOnSurfaceVariant)
          }

          // Signal Strength
          RowLayout {
            visible: modelData.signalStrength !== undefined
            Layout.fillWidth: true
            spacing: Style.marginXS * scaling

            // Device signal strength - "Unknown" when not connected
            NText {
              text: BluetoothService.getSignalStrength(modelData)
              font.pointSize: Style.fontSizeXS * scaling
              color: getContentColor(Colors.mOnSurfaceVariant)
            }

            NIcon {
              visible: modelData.signalStrength > 0 && !modelData.pairing && !modelData.blocked
              icon: BluetoothService.getSignalIcon(modelData)
              font.pointSize: Style.fontSizeXS * scaling
              color: getContentColor(Colors.mOnSurface)
            }

            NText {
              visible: modelData.signalStrength > 0 && !modelData.pairing && !modelData.blocked
              text: (modelData.signalStrength !== undefined && modelData.signalStrength > 0) ? modelData.signalStrength + "%" : ""
              font.pointSize: Style.fontSizeXS * scaling
              color: getContentColor(Colors.mOnSurface)
            }
          }

          // Battery
          NText {
            visible: modelData.batteryAvailable
            text: BluetoothService.getBattery(modelData)
            font.pointSize: Style.fontSizeXS * scaling
            color: getContentColor(Colors.mOnSurfaceVariant)
          }
        }

        // Spacer to push connect button to the right
        Item {
          Layout.fillWidth: true
        }

        // Call to action
        NButton {
          id: button
          visible: (modelData.state !== BluetoothDeviceState.Connecting)
          enabled: (canConnect || canDisconnect) && !isBusy
          outlined: !button.hovered
          fontSize: Style.fontSizeXS * scaling
          fontWeight: Style.fontWeightMedium
          backgroundColor: {
            if (device.canDisconnect && !isBusy) {
              return Colors.mError
            }
            return Colors.mPrimary
          }
          tooltipText: root.tooltipText
          text: {
            if (modelData.pairing) {
              return "Pairing..."
            }
            if (modelData.blocked) {
              return "Blocked"
            }
            if (modelData.connected) {
              return "Disconnect"
            }
            return "Connect"
          }
          icon: (isBusy ? "busy" : null)
          onClicked: {
            if (modelData.connected) {
              BluetoothService.disconnectDevice(modelData)
            } else {
              BluetoothService.connectDeviceWithTrust(modelData)
            }
          }
          onRightClicked: {
            BluetoothService.forgetDevice(modelData)
          }
        }
      }
    }
  }
}
