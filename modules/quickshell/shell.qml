import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import QtQuick // for Text
import QtQuick.Layouts
import qs.Commons
import qs.Modules.Bar
import qs.Modules.Bar.Audio
import qs.Modules.Bar.Bluetooth
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
}
