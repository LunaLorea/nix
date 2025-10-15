pragma Singleton

import QtQuick
import Quickshell
import qs.Modules.Bar.Widgets
import qs.Commons

Singleton {
  id: root

  readonly property var widgetList: {
    "audio": audioComponent,
    "bluetooth": bluetoothComponent,
    "clock": clockComponent,
    "controlCenter": ccComponent,
    "workspaces": wsComponent,
    "wifi": wifiComponent
  }

  readonly property Component audioComponent: Component {
    Audio {}
  }
  readonly property Component bluetoothComponent: Component {
    Bluetooth {}
  }
  readonly property Component clockComponent: Component {
    Clock {}
  }
  readonly property Component ccComponent: Component {
    ControlCenter {}
  }
  readonly property Component wsComponent: Component {
    Workspaces {}
  }
  readonly property Component wifiComponent: Component {
    WiFi {}
  }

  function getWidget(id) {
    return widgetList[id] || null
  }
}
