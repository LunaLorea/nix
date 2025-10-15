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

  preferredWidth: 400 * scaling
  preferredHeight: 500 * scaling


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

        // Header row
        RowLayout {
          id: headerRow
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignTop
          spacing: Style.marginS * scaling
          implicitWidth: contentLayout
          implicitHeight: childrenRect.height

          // Main icon
          NIcon {
            icon: "volume-high"
            color: Colors.mPrimary
            font.pointSize: Style.fontSizeXXL * scaling
          }

          // Main title
          NText {
            text: "Audio Panel"
            font.pointSize: Style.fontSizeXL * scaling
            font.weight: Style.fontWeightBold
            color: Colors.mPrimary
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
          }

          // Close button
          NIconButton {
            icon: "close"
            tooltipText: "Close Audio Panel"
            Layout.alignment: Qt.AlignVCenter
            onClicked: root.close()
          }
        }

        // Divider
        NDivider {
          Layout.fillWidth: true
        }

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

                  ColumnLayout {
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

                    NLabel {
                      label: "Output Volume"
                      description: "System output volume level"
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

                  // Mute Toggle
                  ColumnLayout {
                    spacing: Style.marginS * scaling
                    Layout.fillWidth: true

                    NToggle {
                      label: "Mute audio output"
                      description: "Mute the system's main audio output."
                      checked: AudioService.muted
                      onToggled: checked => {
                        if (AudioService.sink && AudioService.sink.audio) {
                          AudioService.sink.audio.muted = checked
                        }
                      }
                    }
                  }

                  // Input Volume
                  ColumnLayout {
                    spacing: Style.marginXS * scaling
                    Layout.fillWidth: true

                    NLabel {
                      label: "Input Volume"
                      description: "Microphone input volume level"
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

                  // Input Mute Toggle
                  ColumnLayout {
                    spacing: Style.marginS * scaling
                    Layout.fillWidth: true

                    NToggle {
                      label: "Mute audio input"
                      description: "Mute the default audio input (microphone)."
                      checked: AudioService.inputMuted
                      onToggled: checked => AudioService.setInputMuted(checked)
                    }
                  }



                  NDivider {
                    Layout.fillWidth: true
                    Layout.topMargin: Style.marginXL * scaling
                    Layout.bottomMargin: Style.marginXL * scaling
                  }

                  // AudioService Devics
                  ColumnLayout {
                    spacing: Style.marginS * scaling
                    Layout.fillWidth: true

                    NHeader {
                      label: "Audio Devices"
                      description: "Configure available audio input and output devices"
                    }

                    // -------------------------------
                    // Output Devices
                    ButtonGroup {
                      id: sinks
                    }

                    ColumnLayout {
                      spacing: Style.marginXS * scaling
                      Layout.fillWidth: true
                      Layout.bottomMargin: Style.marginL * scaling

                      NLabel {
                        label: "Output device"
                        description: "Select the desired audio output device."
                      }

                      Repeater {
                        model: AudioService.sinks
                        NRadioButton {
                          ButtonGroup.group: sinks
                          required property PwNode modelData
                          text: modelData.description
                          checked: AudioService.sink?.id === modelData.id
                          onClicked: {
                            AudioService.setAudioSink(modelData)
                            localVolume = AudioService.volume
                          }
                          Layout.fillWidth: true
                        }
                      }
                    }

                    // -------------------------------
                    // Input Devices
                    ButtonGroup {
                      id: sources
                    }

                    ColumnLayout {
                      spacing: Style.marginXS * scaling
                      Layout.fillWidth: true

                      NLabel {
                        label: "Input devices"
                        description: "Select the desired audio input device."
                      }

                      Repeater {
                        model: AudioService.sources
                        //Layout.fillWidth: true
                        NRadioButton {
                          ButtonGroup.group: sources
                          required property PwNode modelData
                          text: modelData.description
                          checked: AudioService.source?.id === modelData.id
                          onClicked: AudioService.setAudioSource(modelData)
                          Layout.fillWidth: true
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
