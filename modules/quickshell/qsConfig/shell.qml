import Quickshell

import QtQuick

import qs.Modules.Bar
import qs.Modules.Bar.Audio
import qs.Modules.Bar.Bluetooth
import qs.Modules.Bar.WiFi

import qs.Modules.ControlCenter



ShellRoot {
  id: shellRoot
  
  Bar {}


  BluetoothPanel {
    id: bluetoothPanel
    objectName: "bluetoothPanel"
  }

  ControlCenterPanel {
    id: controlCenterPanel
    objectName: "controlCenterPanel"
  }

  AudioPanel {
    id: audiopanel
    objectName: "audioPanel"
  }
  
  WiFiPanel {
    id: wifipanel
    objectName: "wifiPanel"
  }
}
