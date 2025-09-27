pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // current date
  property var date: new Date()

  Timer {
    interval: 1000
    repeat: true
    running: true
    onTriggered: root.date = new Date()
  }
}
