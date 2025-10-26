import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Services
import qs.Widgets

NPanel {
  id: root

  panelKeyboardFocus: true

  property string passwordSsid: ""
  property string passwordInput: ""
  property string expandedSsid: ""

  onOpened: NetworkService.scan()

  panelContent: Rectangle {
    color: Colors.transparent

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginL
      spacing: Style.marginM

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginM

        NIcon {
          icon: NetworkService.cachedWifiState ? "wifi" : "wifi-off"
          font.pointSize: Style.fontSizeXXL
          color: NetworkService.cachedWifiState ? Colors.mPrimary : Colors.mOnSurfaceVariant
        }

        NText {
          text: "WiFi"
          font.pointSize: Style.fontSizeL
          font.weight: Style.fontWeightBold
          color: Colors.mOnSurface
          Layout.fillWidth: true
        }

        NToggle {
          id: wifiSwitch
          checked: NetworkService.cachedWifiState
          onToggled: checked => NetworkService.setWifiEnabled(checked)
          baseSize: Style.baseWidgetSize * 0.65
        }

        NIconButton {
          icon: "refresh"
          tooltipText: "Refresh"
          baseSize: Style.baseWidgetSize * 0.8
          enabled: NetworkService.cachedWifiState && !NetworkService.scanning
          onClicked: NetworkService.scan()
        }

        NIconButton {
          icon: "close"
          tooltipText: "Close"
          baseSize: Style.baseWidgetSize * 0.8
          onClicked: root.close()
        }
      }

      NDivider {
        Layout.fillWidth: true
      }

      // Error message
      Rectangle {
        visible: NetworkService.lastError.length > 0
        Layout.fillWidth: true
        Layout.preferredHeight: errorRow.implicitHeight + (Style.marginM * 2)
        color: Qt.rgba(Colors.mError.r, Colors.mError.g, Colors.mError.b, 0.1)
        radius: Style.radiusS
        border.width: Math.max(1, Style.borderS)
        border.color: Colors.mError

        RowLayout {
          id: errorRow
          anchors.fill: parent
          anchors.margins: Style.marginM
          spacing: Style.marginS

          NIcon {
            icon: "warning"
            font.pointSize: Style.fontSizeL
            color: Colors.mError
          }

          NText {
            text: NetworkService.lastError
            color: Colors.mError
            font.pointSize: Style.fontSizeS
            wrapMode: Text.Wrap
            Layout.fillWidth: true
          }

          NIconButton {
            icon: "close"
            baseSize: Style.baseWidgetSize * 0.6
            onClicked: NetworkService.lastError = ""
          }
        }
      }

      // Main content area
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Colors.transparent

        // WiFi disabled state
        ColumnLayout {
          visible: !NetworkService.cachedWifiState
          anchors.fill: parent
          spacing: Style.marginM

          Item {
            Layout.fillHeight: true
          }

          NIcon {
            icon: "wifi-off"
            font.pointSize: 64
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: "WiFi is disabled"
            font.pointSize: Style.fontSizeL
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: "WiFi is enabled"
            font.pointSize: Style.fontSizeS
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          Item {
            Layout.fillHeight: true
          }
        }

        // Scanning state
        ColumnLayout {
          visible: NetworkService.cachedWifiState && NetworkService.scanning && Object.keys(NetworkService.networks).length === 0
          anchors.fill: parent
          spacing: Style.marginL

          Item {
            Layout.fillHeight: true
          }

          NBusyIndicator {
            running: true
            color: Colors.mPrimary
            size: Style.baseWidgetSize
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: "Searching for nearby networks..."
            font.pointSize: Style.fontSizeM
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          Item {
            Layout.fillHeight: true
          }
        }

        // Networks list container
        NScrollView {
          visible: NetworkService.cachedWifiState && (!NetworkService.scanning || Object.keys(NetworkService.networks).length > 0)
          anchors.fill: parent
          horizontalPolicy: ScrollBar.AlwaysOff
          verticalPolicy: ScrollBar.AsNeeded
          clip: true

          ColumnLayout {
            width: parent.width
            spacing: Style.marginM

            // Network list
            Repeater {
              model: {
                if (!NetworkService.cachedWifiState)
                  return []

                const nets = Object.values(NetworkService.networks)
                return nets.sort((a, b) => {
                                   if (a.connected !== b.connected)
                                   return b.connected - a.connected
                                   return b.signal - a.signal
                                 })
              }

              Rectangle {
                Layout.fillWidth: true
                implicitHeight: netColumn.implicitHeight + (Style.marginM * 2)
                radius: Style.radiusM

                // Add opacity for operations in progress
                opacity: (NetworkService.disconnectingFrom === modelData.ssid || NetworkService.forgettingNetwork === modelData.ssid) ? 0.6 : 1.0

                color: modelData.connected ? Qt.rgba(Colors.mPrimary.r, Colors.mPrimary.g, Colors.mPrimary.b, 0.05) : Colors.mSurface
                border.width: Math.max(1, Style.borderS)
                border.color: modelData.connected ? Colors.mPrimary : Colors.mOutline

                // Smooth opacity animation
                Behavior on opacity {
                  NumberAnimation {
                    duration: Style.animationNormal
                  }
                }

                ColumnLayout {
                  id: netColumn
                  width: parent.width - (Style.marginM * 2)
                  x: Style.marginM
                  y: Style.marginM
                  spacing: Style.marginS

                  // Main row
                  RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.marginS

                    NIcon {
                      icon: NetworkService.signalIcon(modelData.signal)
                      font.pointSize: Style.fontSizeXXL
                      color: modelData.connected ? Colors.mPrimary : Colors.mOnSurface
                    }

                    MouseArea {
                      anchors.fill: parent.fill
                      enabled: !modelData.connected && NetworkService.connectingTo !== modelData.ssid && passwordSsid !== modelData.ssid && NetworkService.forgettingNetwork !== modelData.ssid && NetworkService.disconnectingFrom !== modelData.ssid
                    }

                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: 2

                      NText {
                        text: modelData.ssid
                        font.pointSize: Style.fontSizeM
                        font.weight: modelData.connected ? Style.fontWeightBold : Style.fontWeightMedium
                        color: Colors.mOnSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }

                      RowLayout {
                        spacing: Style.marginXS

                        NText {
                          text: modelData.signal + "%"
                          font.pointSize: Style.fontSizeXXS
                          color: Colors.mOnSurfaceVariant
                        }

                        NText {
                          text: "•"
                          font.pointSize: Style.fontSizeXXS
                          color: Colors.mOnSurfaceVariant
                        }

                        NText {
                          text: NetworkService.isSecured(modelData.security) ? modelData.security : "Open"
                          font.pointSize: Style.fontSizeXXS
                          color: Colors.mOnSurfaceVariant
                        }

                        Item {
                          Layout.preferredWidth: Style.marginXXS
                        }

                        // Update the status badges area (around line 237)
                        Rectangle {
                          visible: modelData.connected && NetworkService.disconnectingFrom !== modelData.ssid
                          color: Colors.mPrimary
                          radius: height * 0.5
                          width: connectedText.implicitWidth + (Style.marginS * 2)
                          height: connectedText.implicitHeight + (Style.marginXXS * 2)

                          NText {
                            id: connectedText
                            anchors.centerIn: parent
                            text: "WiFi Connected"
                            font.pointSize: Style.fontSizeXXS
                            color: Colors.mOnPrimary
                          }
                        }

                        Rectangle {
                          visible: NetworkService.disconnectingFrom === modelData.ssid
                          color: Colors.mError
                          radius: height * 0.5
                          width: disconnectingText.implicitWidth + (Style.marginS * 2)
                          height: disconnectingText.implicitHeight + (Style.marginXXS * 2)

                          NText {
                            id: disconnectingText
                            anchors.centerIn: parent
                            text: "Disconnecting..."
                            font.pointSize: Style.fontSizeXXS
                            color: Colors.mOnPrimary
                          }
                        }

                        Rectangle {
                          visible: NetworkService.forgettingNetwork === modelData.ssid
                          color: Colors.mError
                          radius: height * 0.5
                          width: forgettingText.implicitWidth + (Style.marginS * 2)
                          height: forgettingText.implicitHeight + (Style.marginXXS * 2)

                          NText {
                            id: forgettingText
                            anchors.centerIn: parent
                            text: "Forgetting..."
                            font.pointSize: Style.fontSizeXXS
                            color: Colors.mOnPrimary
                          }
                        }

                        Rectangle {
                          visible: modelData.cached && !modelData.connected && NetworkService.forgettingNetwork !== modelData.ssid && NetworkService.disconnectingFrom !== modelData.ssid
                          color: Colors.transparent
                          border.color: Colors.mOutline
                          border.width: Math.max(1, Style.borderS)
                          radius: height * 0.5
                          width: savedText.implicitWidth + (Style.marginS * 2)
                          height: savedText.implicitHeight + (Style.marginXXS * 2)

                          NText {
                            id: savedText
                            anchors.centerIn: parent
                            text: "Saved"
                            font.pointSize: Style.fontSizeXXS
                            color: Colors.mOnSurfaceVariant
                          }
                        }
                      }
                    }

                    // Action area
                    RowLayout {
                      spacing: Style.marginS

                      NBusyIndicator {
                        visible: NetworkService.connectingTo === modelData.ssid || NetworkService.disconnectingFrom === modelData.ssid || NetworkService.forgettingNetwork === modelData.ssid
                        running: visible
                        color: Colors.mPrimary
                        size: Style.baseWidgetSize * 0.5
                      }

                      NIconButton {
                        visible: (modelData.existing || modelData.cached) && !modelData.connected && NetworkService.connectingTo !== modelData.ssid && NetworkService.forgettingNetwork !== modelData.ssid && NetworkService.disconnectingFrom !== modelData.ssid
                        icon: "trash"
                        tooltipText: "Forget this network?"
                        baseSize: Style.baseWidgetSize * 0.8
                        onClicked: expandedSsid = expandedSsid === modelData.ssid ? "" : modelData.ssid
                      }

                      NIconButton {
                        visible: !modelData.connected && NetworkService.connectingTo !== modelData.ssid && passwordSsid !== modelData.ssid && NetworkService.forgettingNetwork !== modelData.ssid && NetworkService.disconnectingFrom !== modelData.ssid
                        icon: "connect"
                        enabled: !NetworkService.connecting
                        onClicked: {
                          if (modelData.existing || modelData.cached || !NetworkService.isSecured(modelData.security)) {
                            NetworkService.connect(modelData.ssid)
                          } else {
                            passwordSsid = modelData.ssid
                            passwordInput = ""
                            expandedSsid = ""
                          }
                        }
                      }

                      NIconButton {
                        visible: modelData.connected && NetworkService.disconnectingFrom !== modelData.ssid
                        icon: "close"
                        colorBg: Colors.mSurfaceVariant
                        onClicked: NetworkService.disconnect(modelData.ssid)
                      }
                    }
                  }

                  // Password input
                  Rectangle {
                    visible: passwordSsid === modelData.ssid && NetworkService.disconnectingFrom !== modelData.ssid && NetworkService.forgettingNetwork !== modelData.ssid
                    Layout.fillWidth: true
                    height: passwordRow.implicitHeight + Style.marginS * 2
                    color: Colors.mSurfaceVariant
                    border.color: Colors.mOutline
                    border.width: Math.max(1, Style.borderS)
                    radius: Style.radiusS

                    RowLayout {
                      id: passwordRow
                      anchors.fill: parent
                      anchors.margins: Style.marginS
                      spacing: Style.marginM

                      Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.radiusXS
                        color: Colors.mSurface
                        border.color: pwdInput.activeFocus ? Colors.mSecondary : Colors.mOutline
                        border.width: Math.max(1, Style.borderS)

                        TextInput {
                          id: pwdInput
                          anchors.left: parent.left
                          anchors.right: parent.right
                          anchors.verticalCenter: parent.verticalCenter
                          anchors.margins: Style.marginS
                          text: passwordInput
                          font.pointSize: Style.fontSizeS
                          color: Colors.mOnSurface
                          echoMode: TextInput.Password
                          selectByMouse: true
                          focus: visible
                          passwordCharacter: "●"
                          onTextChanged: passwordInput = text
                          onVisibleChanged: if (visible)
                                              forceActiveFocus()
                          onAccepted: {
                            if (text && !NetworkService.connecting) {
                              NetworkService.connect(passwordSsid, text)
                              passwordSsid = ""
                              passwordInput = ""
                            }
                          }

                          NText {
                            visible: parent.text.length === 0
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Enter password..."
                            color: Colors.mOnSurfaceVariant
                            font.pointSize: Style.fontSizeS
                          }
                        }
                      }

                      NButton {
                        text: "Connect"
                        fontSize: Style.fontSizeXXS
                        enabled: passwordInput.length > 0 && !NetworkService.connecting
                        outlined: true
                        onClicked: {
                          NetworkService.connect(passwordSsid, passwordInput)
                          passwordSsid = ""
                          passwordInput = ""
                        }
                      }

                      NIconButton {
                        icon: "close"
                        baseSize: Style.baseWidgetSize * 0.8
                        onClicked: {
                          passwordSsid = ""
                          passwordInput = ""
                        }
                      }
                    }
                  }

                  // Forget network
                  Rectangle {
                    visible: expandedSsid === modelData.ssid && NetworkService.disconnectingFrom !== modelData.ssid && NetworkService.forgettingNetwork !== modelData.ssid
                    Layout.fillWidth: true
                    height: forgetRow.implicitHeight + Style.marginS * 2
                    color: Colors.mSurfaceVariant
                    radius: Style.radiusS
                    border.width: Math.max(1, Style.borderS)
                    border.color: Colors.mOutline

                    RowLayout {
                      id: forgetRow
                      anchors.fill: parent
                      anchors.margins: Style.marginS
                      spacing: Style.marginM

                      RowLayout {
                        NIcon {
                          icon: "trash"
                          font.pointSize: Style.fontSizeL
                          color: Colors.mError
                        }

                        NText {
                          text: "Forget this network?"
                          font.pointSize: Style.fontSizeS
                          color: Colors.mError
                          Layout.fillWidth: true
                        }
                      }

                      NButton {
                        id: forgetButton
                        text: "Forget"
                        fontSize: Style.fontSizeXXS
                        backgroundColor: Colors.mError
                        outlined: forgetButton.hovered ? false : true
                        onClicked: {
                          NetworkService.forget(modelData.ssid)
                          expandedSsid = ""
                        }
                      }

                      NIconButton {
                        icon: "close"
                        baseSize: Style.baseWidgetSize * 0.8
                        onClicked: expandedSsid = ""
                      }
                    }
                  }
                }
              }
            }
          }
        }

        // Empty state when no networks
        ColumnLayout {
          visible: NetworkService.cachedWifiState && !NetworkService.scanning && Object.keys(NetworkService.networks).length === 0
          anchors.fill: parent
          spacing: Style.marginL

          Item {
            Layout.fillHeight: true
          }

          NIcon {
            icon: "search"
            font.pointSize: 64
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: "No networks found"
            font.pointSize: Style.fontSizeL
            color: Colors.mOnSurfaceVariant
            Layout.alignment: Qt.AlignHCenter
          }

          NButton {
            text: "Scan again"
            icon: "refresh"
            Layout.alignment: Qt.AlignHCenter
            onClicked: NetworkService.scan()
          }

          Item {
            Layout.fillHeight: true
          }
        }
      }
    }
  }
}
