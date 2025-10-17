import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets
import qs.Services

Item {
  id: root
  implicitWidth: childrenRect.width
  implicitHeight: Style.capsuleHeight

  property string tooltipText: finished + " pomodoro" + (finished != 1 ? "s" : "") + " completed today."
  property real scaling: 1
  property ShellScreen screen

  property int duration: 25
  property int breakDuration: 5
  property int longBreakDuration: 15
  property int completedPomodoros: 0

  property int state: 0
  readonly property var states: {
    "defaultW": 0,
    "working": 1,
    "pauseW": 2,
    "defaultB": 3,
    "break": 4,
    "pauseB": 5,
  }

  property int finished: 0
  property real completeness: 0
  property int currentDuration: duration * 60
  property int remainingTime: duration * 60
  property string display: (duration < 10 ? "0" : "") + duration + ":00"

  property string icon: getIcon()

  function getIcon() {
    switch (state) {
      case 0:
      return "pomodoro"
      case 1: 
      return "pomodoro-working"
      case 2:
      case 5:
      return "pomodoro-pause"
      case 3:
      case 4:
      return "pomodoro-break"
      default:
      return "pomodoro"
    }
  }


  property int wheelAccumulator: 0

  Timer {
    id: pomodoro
    interval: 1000
    repeat: true
    running: false
    onTriggered: root.update()
  }

  Timer {
    id: dailyReset
    interval: 86400000
    repeat: true
    running: false
    onTriggered: root.finished = 0
  }

  function start() {
    switch (state) {
      case 0:
      state = 1
      currentDuration = duration * 60
      remainingTime = currentDuration
      completeness = 0
      pomodoro.running = true
      break;
      case 1:
      state = 2
      pomodoro.running = false
      break;
      case 2:
      state = 1
      pomodoro.running = true
      break;
      case 3:
      state = 4
      currentDuration = (finished % 4 == 0) ? longBreakDuration * 60 : breakDuration * 60
      remainingTime = currentDuration
      completeness = 1
      pomodoro.running = true
      break;
      case 4:
      state = 5
      pomodoro.running = false
      break;
      case 5:
      state = 4
      pomodoro.running = true
      break;
    }

  }

  function update() {
    if (remainingTime <= 0) {
      pomodoro.running = false
      if ( state == 1 ) { 
        state = 3
        finished += 1
        if (finished % 4 != 0) {
          display = (breakDuration < 10 ? "0" : "") + breakDuration + ":00"
        } else {
          display = (longBreakDuration < 10 ? "0" : "") + longBreakDuration + ":00"
        }
      }
      if ( state == 4 ) { 
        state = 0 
        display = (duration < 10 ? "0" : "") + duration + ":00"
      }
      return
    }
    remainingTime -= 1
    const min = Math.floor(remainingTime / 60)
    const sec = remainingTime % 60
    display = (min < 10 ? "0" : "") + min + ":" + (sec < 10 ? "0" : "") + sec
    completeness = state == 1 ? ((currentDuration - remainingTime) / currentDuration) : (remainingTime / currentDuration)
  }

  function leftClick() {
    start()
  }

  function rightClick() {
    state = 0
    pomodoro.running = false
    currentDuration = duration * 60
    remainingTime = 0
    completeness = 0
    display = (duration < 10 ? "0" : "") + duration + ":00"
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    hoverEnabled: true
    onClicked: function(mouse) {
      if (mouse.button === Qt.LeftButton) {
        root.leftClick()
      } else if (mouse.button === Qt.RightButton) {
        root.rightClick()
      }
      TooltipService.hide()
    }
    onWheel: function (wheel) {
      if ( root.state != 0 && root.state != 3 ) { return } 
      root.wheelAccumulator += wheel.angleDelta.y
      var delta = 0
      if (root.wheelAccumulator >= 120) {
        root.wheelAccumulator = 0
        delta = 1
      } else if (root.wheelAccumulator <= -120) {
        root.wheelAccumulator = 0
        delta = -1
      }
      if (root.state == 0) {
        root.duration =  Math.max(root.duration + delta, 1)
        root.display = (root.duration < 10 ? "0" : "") + root.duration + ":00"
      }
      if (root.state == 3 && root.finished % 4 != 0) {
        root.breakDuration = Math.max(root.breakDuration + delta, 1)
        root.display = (root.breakDuration < 10 ? "0" : "") + root.breakDuration + ":00"
      }
      if (root.state == 3 && root.finished % 4 == 0) {
        root.longBreakDuration = Math.max(root.longBreakDuration + delta, 1)
        root.display = (root.longBreakDuration < 10 ? "0" : "") + root.longBreakDuration + ":00"
      }
    }
    onEntered: {
      TooltipService.show(root, root.tooltipText, "auto", 1000)
    }
    onExited: {
      TooltipService.hide()
    }
  }


  Rectangle {
    width: (childrenRect.width + Style.marginM * 2)
    height: 25 * root.scaling
    radius: Style.radiusXS * root.scaling
    color: Colors.transparent
    anchors.centerIn: parent

    RowLayout {
      anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        leftMargin: Style.marginM
      }
      spacing: Style.marginS * root.scaling
      NIcon {
        icon: root.icon
        font.pointSize: Style.capsuleHeight * 0.48 * root.scaling
      }

      NText {
        text: root.display
        scaling: root.scaling
        Layout.alignment: Qt.AlignVCenter
      }
    }
  }
  Rectangle {
    id: progressBar
    property real completeness: root.completeness
    visible: root.state != 0
    width: ((childrenRect.width + Style.marginM * 2) * ((0.49 < completeness && 0.51 > completeness) ? 0.49 : completeness))
    height: 25 * root.scaling
    radius: Style.radiusXS * root.scaling
    color: getColor()
    function getColor() {
      switch (root.state) {
        case 1:
        return Colors.mTertiary
        case 2:
        case 5:
        return Colors.mWarning
        case 3:
        case 4:
        return Colors.mGreen
        default:
        return Colors.transparent
      }
    }
    //? Colors.mWarning : ((root.done) ? Colors.mGreen : Colors.mTertiary)
    anchors {
      verticalCenter: parent.verticalCenter
    }
    clip: true

    Behavior on width {
      NumberAnimation {
        duration: 1000
        easing.type: Easing.Linear
      }
    }

    RowLayout {
      anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        leftMargin: Style.marginM
      }
      spacing: Style.marginS * root.scaling
      NIcon {
        icon: root.icon
        font.pointSize: Style.capsuleHeight * 0.48 * root.scaling
        color: Colors.mOnPrimary
      }

      NText {
        text: root.display
        scaling: root.scaling
        Layout.alignment: Qt.AlignVCenter
        color: Colors.mOnPrimary
        elide: Text.ElideNone
      }
    }
  }
}
