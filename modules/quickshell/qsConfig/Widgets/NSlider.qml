import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.Commons
import qs.Services

Slider {
  id: root

  property var cutoutColor: Colors.mSurface
  property bool snapAlways: false
  property real heightRatio: 0.7

  readonly property real knobDiameter: Math.round((Style.baseWidgetSize * heightRatio * scaling) / 2) * 2
  readonly property real trackHeight: Math.round((knobDiameter * 0.4) / 2) * 2
  readonly property real cutoutExtra: 0

  property int wheelAccumulator: 0

  padding: cutoutExtra / 2

  snapMode: snapAlways ? Slider.SnapAlways : Slider.SnapOnRelease
  implicitHeight: Math.max(trackHeight, knobDiameter)

  stepSize: 0.2

  background: Rectangle {
    y: root.topPadding + root.availableHeight / 2 - height / 2
    implicitWidth: Style.sliderWidth
    implicitHeight: trackHeight
    height: implicitHeight
    radius: Style.marginXXS
    color: Colors.mOutline

    // A container composite shape that puts a semicircle on the end
    Item {
      id: activeTrackContainer
      width: parent.width
      height: parent.height
      clip: true


      // The main rectangle
      Rectangle {
        x: parent.height / 2
        width: root.visualPosition * parent.width
        anchors.left: parent.left
        height: parent.height
        radius: Style.marginXXS
        // Animated gradient fill
        gradient: Gradient {
          orientation: Gradient.Horizontal
          GradientStop {
            position: 0.0
            color: Qt.darker(Colors.mTertiary, 1.2)
            Behavior on color {
              ColorAnimation {
                duration: 300
              }
            }
          }
          GradientStop {
            position: 0.5
            color: Colors.mTertiary
            SequentialAnimation on position {
              loops: Animation.Infinite
              NumberAnimation {
                from: 0.3
                to: 0.7
                duration: 2000
                easing.type: Easing.InOutSine
              }
              NumberAnimation {
                from: 0.7
                to: 0.3
                duration: 2000
                easing.type: Easing.InOutSine
              }
            }
          }
          GradientStop {
            position: 1.0
            color: Qt.lighter(Colors.mPrimary, 1.2)
          }
        }
      }
    }
  }

  handle: Item {
    implicitWidth: 0
    implicitHeight: 0
    anchors.verticalCenter: parent.verticalCenter

    Rectangle {
      id: knob
      color: Colors.transparent
      anchors.fill: parent
    }
  }
    MouseArea {
      anchors.fill: parent
      onWheel: function(wheel) {
        root.wheelAccumulator += wheel.angleDelta.y
        if (root.wheelAccumulator >= 120) {
          root.wheelAccumulator = 0
          root.increase()
        } else if (root.wheelAccumulator <= -120) {
          root.wheelAccumulator = 0
          root.decrease()
        }
      }
    }
}
