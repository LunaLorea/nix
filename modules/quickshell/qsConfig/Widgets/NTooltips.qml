import QtQuick
import "../Commons"

Window {
  id: root

  property bool isVisible: false
  property string text: "Placeholder tooltip"
  property Item target: null
  property int delay: 1

  flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
  color: Colors.transparent
  visible: false
  
  onIsVisibleChanged: {
    if (isVisible) {
      if (delay > 0) {
        timerShow.running = true
      } else {
        _showNow()
      }
    } else {
      _hideNow()
    }
  }

  function show() {
    isVisible = true
  }
  function hide() {
    isVisible = false
    timerShow.running = false
  }

  function _showNow() {
    // Compute new size everytime we show the tooltip
    width = Math.max(50, tooltipText.implicitWidth + Style.marginL * 2)
    height = Math.max(40, tooltipText.implicitHeight + Style.marginM * 2)

    if (!target) {
      return
    }

    // Position tooltip below the target
    var pos = target.mapToGlobal(0, target.height)
    x = pos.x - width / 2 + target.width / 2
    y = pos.y + 12 // 12 px margin below
    

    // Start with animation values
    tooltipRect.scaleValue = 0.8
    tooltipRect.opacityValue = 0.0
    visible = true

    // Use a timer to trigger the animation after the component is visible
    showTimer.start()
  }

  function _hideNow() {
    // Start hide animation
    tooltipRect.scaleValue = 0.8
    tooltipRect.opacityValue = 0.0

    // Hide after animation completes
    hideTimer.start()
  }

  Connections {
    target: root.target
    function onXChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
    function onYChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
    function onWidthChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
    function onHeightChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
  }
  Connections {
    target: root
    function onTextChanged() {
      if (root.visible) {
        root._showNow()
      }
    }
  }

  Timer {
    id: timerShow
    interval: delay
    running: false
    repeat: false
    onTriggered: {
      _showNow()
      running = false
    }
  }

  // Timer to hide tooltip after animation
  Timer {
    id: hideTimer
    interval: 300
    repeat: false
    onTriggered: {
      visible = false
    }
  }

  // Timer to trigger show animation
  Timer {
    id: showTimer
    interval: 10 // Very short delay to ensure component is visible
    repeat: false
    onTriggered: {
      // Animate to final values
      tooltipRect.scaleValue = 1.0
      tooltipRect.opacityValue = 1.0
    }
  }

  Rectangle {
    id: tooltipRect
    anchors.fill: parent
    radius: Style.radiusM
    color: Colors.mSurface
    border.color: Colors.mOutline
    border.width: Math.max(1, Style.borderS)
    z: 1

    // Animation properties
    property real scaleValue: 1.0
    property real opacityValue: 1.0

    scale: scaleValue
    opacity: opacityValue

    // Animation behaviors
    Behavior on scale {
      NumberAnimation {
        duration: 300
        easing.type: Easing.OutExpo
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: 300
        easing.type: Easing.OutQuad
      }
    }

    NText {
      id: tooltipText
      anchors.centerIn: parent
      text: root.text
      font.pointSize: Style.fontSizeM
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      wrapMode: Text.Wrap
    }
  }
}
