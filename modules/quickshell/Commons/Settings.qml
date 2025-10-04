pragma Singleton

import Quickshell
import QtQuick
import qs.Commons

Singleton {
  id: root

  // --- Bar Settings
  property real backgroundOpacity: 1
  property string barPosition: "top" // "top" "bottom"
  property list<string> barMonitors: []

  // --- Clock Settings
  property string clockFormat: "HH:mm"


  // --- Monitors
  property list<var> monitorsScaling: [
    {
      "name": "eDP-1",
      "scale": 1.5
    }
  ]

  signal settingsLoaded

  Component.onCompleted: {
    Logger.log("Settings", "Settings loaded")
    settingsLoaded()
  }
}
