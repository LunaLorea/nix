import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Commons
import qs.Services


Rectangle {
  id: root

  property ShellScreen screen
  property real scaling: 1.0

  property real baseSize: Style.baseWidgetSize

  property string icon
  property string tooltipText
  property string tooltipDirection
  
  property bool enabled: true
  property bool allowClickWhenDisabled: false
  property bool hovering: false

  property color colorBg: Settings.bar.backgroundOpacity.section > 0 ?
    (Settings.bar.capsule ? Colors.mSurfaceVariant : Colors.mSurface) : Colors.transparent
  property color colorFg: Colors.mOnSurface
  property color colorBgHover: Colors.mTertiary
  property color colorFgHover: Colors.mOnTertiary

  signal entered
  signal exited
  signal clicked
  signal rightClicked
  signal middleClicked
  signal wheel(int delta)

  implicitWidth: baseSize
  implicitHeight: baseSize


  color: root.enabled && root.hovering ? colorBgHover : colorBg
  radius: Settings.bar.capsule ? width * 0.5 : Style.radiusXS

  Behavior on color {
    ColorAnimation {
      duration: Style.animationNormal
      easing.type: Easing.InOutQuad
    }
  }


  NIcon {
    icon: root.icon
    font.pointSize: Math.max(1, root.width * 0.48 * scaling)
    color: root.enabled && root.hovering ? colorFgHover : colorFg

    x: (root.width - width) / 2
    y: (root.height - height) / 2 + (height - contentHeight) / 2

    
    Behavior on color {
      ColorAnimation {
        duration: Style.animationFast
        easing.type: Easing.InOutQuad
      }
    }
  }

  MouseArea {
    enabled: true
    anchors.fill: parent
    cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    hoverEnabled: true
    onEntered: {
      hovering = root.enabled ? true : false
      TooltipService.show(root, root.tooltipText, "auto", 1000)
      root.entered()
    }
    onExited: {
      hovering = false
      TooltipService.hide()
      root.exited()
    }
    onClicked: function (mouse) {
      TooltipService.hide()

      if (!root.enabled && root.allowClickWhenDisabled) {
        return
      }
      if (mouse.button === Qt.LeftButton) {
        root.clicked()
      } else if (mouse.button === Qt.RightButton) {
        root.rightClicked()
      } else if (mouse.button === Qt.MiddleClick) {
        root.middleClicked()
      }
    }
    onWheel: wheel => root.wheel(wheel.angleDelta.y)
  }
}
