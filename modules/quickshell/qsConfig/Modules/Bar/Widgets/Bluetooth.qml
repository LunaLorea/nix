import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

NIconButton {
  id: root

  property real scaling: 1.0
  property ShellScreen screen


  tooltipText: "Open bluetooth widget."
  baseSize: Style.capsuleHeight * scaling
  icon: BluetoothService.discovering ? "bluetooth-disc" : (BluetoothService.enabled ? "bluetooth-on" : "bluetooth-off")
  onClicked: PanelService.getPanel("bluetoothPanel")?.toggle(this)
  onRightClicked: BluetoothService.setBluetoothEnabled(!BluetoothService.enabled)
}
