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

  preferredWidth: 500 * scaling
  preferredHeight: 700 * scaling


  panelKeyboardFocus: true
  scaling: 1

  property var activeScrollView: null


  property real localVolume: AudioService.volume

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
          spacing: Style.marginS * scaling
          implicitWidth: contentLayout

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
        ColumnLayout {
          spacing: Style.marginXS * scaling
          Layout.fillWidth: true

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
