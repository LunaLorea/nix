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

  property ShellScreen screen

  baseSize: Style.capsuleHeight
  tooltipText: "Manage Wi-Fi"
  icon: {
    try {
      if (NetworkService.ethernetConnected) {
        return "ethernet"
      }
      let connected = false
      let signalStrength = 0
      for (const net in NetworkService.networks) {
        if (NetworkService.networks[net].connected) {
          connected = true
          signalStrength = NetworkService.networks[net].signal
          break
        }
      }
      return connected ? NetworkService.signalIcon(signalStrength) : "wifi-off"
    } catch (error) {
      Logger.error("Wi-Fi", "Error getting icon:", error)
      return "signal_wifi_bad"
    }
  }
  onClicked: PanelService.getPanel("wifiPanel")?.toggle(this)
  onRightClicked: Quickshell.execDetached(["nm-connection-editor"])
}
