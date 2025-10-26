import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import qs.Commons
import qs.Services
import qs.Widgets

NPanel {
  id: root

  panelKeyboardFocus: true

  property var activeScrollView: null


  property real localVolume: AudioService.volume

  // Add scroll functions
  function scrollDown() {
    if (activeScrollView && activeScrollView.ScrollBar.vertical) {
      const scrollBar = activeScrollView.ScrollBar.vertical
      const stepSize = activeScrollView.height * 0.1 // Scroll 10% of viewport
      scrollBar.position = Math.min(scrollBar.position + stepSize / activeScrollView.contentHeight, 1.0 - scrollBar.size)
    }
  }

  function scrollUp() {
    if (activeScrollView && activeScrollView.ScrollBar.vertical) {
      const scrollBar = activeScrollView.ScrollBar.vertical
      const stepSize = activeScrollView.height * 0.1 // Scroll 10% of viewport
      scrollBar.position = Math.max(scrollBar.position - stepSize / activeScrollView.contentHeight, 0)
    }
  }

  function scrollPageDown() {
    if (activeScrollView && activeScrollView.ScrollBar.vertical) {
      const scrollBar = activeScrollView.ScrollBar.vertical
      const pageSize = activeScrollView.height * 0.9 // Scroll 90% of viewport
      scrollBar.position = Math.min(scrollBar.position + pageSize / activeScrollView.contentHeight, 1.0 - scrollBar.size)
    }
  }

  function scrollPageUp() {
    if (activeScrollView && activeScrollView.ScrollBar.vertical) {
      const scrollBar = activeScrollView.ScrollBar.vertical
      const pageSize = activeScrollView.height * 0.9 // Scroll 90% of viewport
      scrollBar.position = Math.max(scrollBar.position - pageSize / activeScrollView.contentHeight, 0)
    }
  }

  panelContent: ColumnLayout {

    id: contentLayout
    anchors.fill: parent
    spacing: Style.marginS * scaling


    // Tab content area
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Colors.transparent



      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.marginL * scaling


        // Tab content area
        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: Colors.transparent

          Flickable {
            id: flickable
            anchors.fill: parent
            pressDelay: 200

            NScrollView {
              id: scrollView
              anchors.fill: parent
              horizontalPolicy: ScrollBar.AlwaysOff
              verticalPolicy: ScrollBar.AsNeeded
              padding: Style.marginL
              Component.onCompleted: {
                root.activeScrollView = scrollView
              }

              Loader {
                id: loader
                active: true
                width: scrollView.availableWidth
                sourceComponent: ColumnLayout {
                  anchors.margins: Style.marginL * scaling
                  implicitWidth: contentLayout

                  RowLayout {
                    id: inputSlider
                    spacing: Style.marginXS * scaling

                    // Pipewire seems a bit finicky, if we spam too many volume changes it breaks easily
                    // Probably because they have some quick fades in and out to avoid clipping
                    // We use a timer to space out the updates, to avoid lock up
                    Timer {
                      interval: 100
                      running: true
                      repeat: true
                      onTriggered: {
                        if (Math.abs(localVolume - AudioService.volume) >= 0.01) {
                          AudioService.setVolume(localVolume)
                        }
                      }
                    }

                    Connections {
                      target: AudioService.sink?.audio ? AudioService.sink?.audio : null
                      function onVolumeChanged() {
                        localVolume = AudioService.volume
                      }
                    }


                    NIconButton{
                      icon: getIcon()
                      onClicked: {
                        AudioService.setOutputMuted(!AudioService.muted)
                      }

                      function getIcon() {
                        if (AudioService.muted) {
                          return "volume-mute"
                        }
                        return (AudioService.volume <= Number.EPSILON) ? "volume-zero" : (AudioService.volume <= 0.5) ? "volume-low" : "volume-high"
                      }
                    }

                    NValueSlider {
                      Layout.fillWidth: true
                      from: 0
                      to: 1.0
                      value: localVolume
                      stepSize: 0.01
                      text: Math.round(AudioService.volume * 100) + "%"
                      onMoved: value => localVolume = value
                    }
                  }

                  ButtonGroup {
                    id: sinks
                  }

                  ColumnLayout {
                    spacing: Style.marginXS * scaling
                    implicitWidth: inputSlider.width
                    Layout.bottomMargin: Style.marginL * scaling
                    Layout.leftMargin: Style.marginS

                    Repeater {
                      id: sinkRepeater
                      model: AudioService.sinks
                      Item {
                        Layout.fillWidth: true
                        implicitHeight: childrenRect.height
                        RowLayout {
                          implicitWidth: parent.width
                          property color textColor: AudioService.sink?.id === modelData.id ? Colors.mTertiary : Colors.mOnSurfaceVariant
                          NText {
                            text: "["
                            color: parent.textColor
                            Layout.alignment: Qt.AlignLeft
                          }
                          NText {
                            text: modelData.description
                            color: parent.textColor
                            Layout.alignment: Qt.AlignLeft
                            Layout.fillWidth: true
                          }
                          NText {
                            text: "]"
                            color: parent.textColor
                            Layout.alignment: Qt.AlignRight
                          }

                        }

                        MouseArea {
                          anchors.fill: parent
                          onClicked: {
                            AudioService.setAudioSink(modelData)
                            localVolume = AudioService.volume
                          }
                        }
                      }
                    }
                  }



                  // Input Volume
                  RowLayout {
                    spacing: Style.marginXS * scaling
                    Layout.fillWidth: true

                    NIconButton {
                      icon: AudioService.inputMuted ? "microphone-mute" : "microphone"
                      onClicked: AudioService.setInputMuted(!AudioService.inputMuted)
                    }

                    NValueSlider {
                      Layout.fillWidth: true
                      from: 0
                      to: 1.0
                      value: AudioService.inputVolume
                      stepSize: 0.01
                      text: Math.round(AudioService.inputVolume * 100) + "%"
                      onMoved: value => AudioService.setInputVolume(value)
                    }
                  }
                  ButtonGroup {
                    id: sources
                  }

                  ColumnLayout {
                    spacing: Style.marginXS * scaling
                    Layout.fillWidth: true
                    Layout.leftMargin: Style.marginS

                    Repeater {
                      model: AudioService.sources
                      //Layout.fillWidth: true
                      Item {
                        Layout.fillWidth: true
                        implicitHeight: childrenRect.height
                        RowLayout {
                          implicitWidth: parent.width
                          property color textColor: AudioService.source?.id === modelData.id ? Colors.mTertiary : Colors.mOnSurfaceVariant
                          NText {
                            text: "["
                            color: parent.textColor
                            Layout.alignment: Qt.AlignLeft
                          }
                          NText {
                            text: modelData.description
                            color: parent.textColor
                            Layout.alignment: Qt.AlignLeft
                            Layout.fillWidth: true
                          }
                          NText {
                            text: "]"
                            color: parent.textColor
                            Layout.alignment: Qt.AlignRight
                          }

                        }

                        MouseArea {
                          anchors.fill: parent
                          onClicked: {
                            AudioService.setAudioSource(modelData)
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
