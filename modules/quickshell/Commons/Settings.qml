pragma Singleton

import Quickshell
import QtQuick
import qs.Commons

Singleton {
  id: root

  // --- Bar Settings
  property real backgroundOpacity: 1
  property string barPosition: "bottom" // "top" "bottom"
  property list<string> barMonitors: []

  // --- Clock Settings
  property string clockFormat: "HH:mm"

  signal settingsLoaded

  Component.onCompleted: {
    Logger.log("Settings", "Settings loaded")
    settingsLoaded()
  }
}
