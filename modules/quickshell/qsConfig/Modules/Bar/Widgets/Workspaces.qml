import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services
import qs.Widgets


Item {
  id: root

  property real scaling: 1
  property ShellScreen screen

  property bool isDestroying: false
  property real baseSize: Style.baseWidgetSize

  property ListModel localWorkspaces: ListModel {}

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  function getFocusedLocalIndex() {
    for (var i = 0; i < localWorkspaces.count; i++) {
      if (localWorkspaces.get(i).isFocused === true)
      return i
    }
    return -1
  }


  Component.onCompleted: {
    refreshWorkspaces()
  }

  onScreenChanged: refreshWorkspaces()

  Connections {
    target: CompositorService
    function onWorkspacesChanged() {
      refreshWorkspaces()
    }
  }

  function refreshWorkspaces() {
    localWorkspaces.clear()
    if (screen !== null) {
      Logger.log("test")
      for (var i = 0; i < CompositorService.workspaces.count; i++) {
        const ws = CompositorService.workspaces.get(i)
        localWorkspaces.append(ws)
      }
    }
    workspaceRepeater.model = localWorkspaces
    Logger.log("Workspaces", localWorkspaces.count)
  }

  RowLayout {
    spacing: Style.marginS * scaling

    Repeater {
      id: workspaceRepeater
      model: root.localWorkspaces

      Rectangle {
        width: (Settings.bar.capsule ? (model.isFocused ? 40 : Style.capsuleHeight) : Style.capsuleHeight) * scaling
        height: 25 * scaling
        color: model.isFocused ? Colors.mOutline : Colors.mSurface
        radius: (Settings.bar.capsule ? width * 0.5 : Style.radiusXS) * scaling

        Behavior on color {
          ColorAnimation {
            duration: Style.animationFast
            easing.type: Easing.InOutQuad
          }
        }
        Behavior on width {
          NumberAnimation {
            duration: Style.animationNormal
            easing.type: Easing.OutBack
          }
        }

        property color text: Colors.mOnSurface

        NText {
          anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
          }
          Behavior on color {
            ColorAnimation {
              duration: Style.animationFast
              easing.type: Easing.InOutQuad
            }
          }

          text: model.name
          color: parent.text
          scaling: scaling
        }

        MouseArea {
          anchors.fill: parent

          hoverEnabled: true

          onEntered: {
            parent.color = Colors.mTertiary
            parent.text = Colors.mOnTertiary
          }
          onExited: {
            parent.color = model.isFocused ? Colors.mOutline : Colors.mSurface
            parent.text = Colors.mOnSurface
          }

          onClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
              CompositorService.switchToWorkspace(model)
            }
          }
        }
      }
    }
  }
}
