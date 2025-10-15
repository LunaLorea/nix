import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.Commons
import qs.Services
import qs.Widgets

NIconButton {
  id: root

  property ShellScreen screen
  property real scaling: 1.0

  // Used to avoid opening the pill on Quickshell startup
  property bool firstVolumeReceived: false
  property int wheelAccumulator: 0


  function getIcon() {
    if (AudioService.muted) {
      return "volume-mute"
    }
    return (AudioService.volume <= Number.EPSILON) ? "volume-zero" : (AudioService.volume <= 0.5) ? "volume-low" : "volume-high"
  }

  tooltipText: "Scroll to change Volume click to mute\nrightclick to open audio Panel\nmiddle click to open pwvucontroll\nVolume: " 
  baseSize: Style.capsuleHeight * scaling
  icon: getIcon()
  
  onWheel: function (delta) {
    wheelAccumulator += delta
    if (wheelAccumulator >= 120) {
      wheelAccumulator = 0
      AudioService.increaseVolume()
    } else if (wheelAccumulator <= -120) {
      wheelAccumulator = 0
      AudioService.decreaseVolume()
    }
  }
  onRightClicked: {
    AudioService.setOutputMuted(!AudioService.muted)
  }
  onClicked: PanelService.getPanel("audioPanel")?.toggle(this)

  onMiddleClicked: {
    Logger.Log("audio widget", "middleclich")
    Quickshell.execDetached(["pwvucontrol"])
  }
}
