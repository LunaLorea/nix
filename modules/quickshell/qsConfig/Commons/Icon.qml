pragma Singleton

import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Commons

Singleton {
  id: root

  readonly property string defaultIcon: "placeholder"

  function get(iconName) {
    if (icons[iconName] !== undefined) {
      return icons[iconName]
    } else {
      return icons["placeholder"]
    }
  }

  readonly property var icons: {
    "placeholder": "󱗽",
    "stop": "󰓛",
    "refresh": "󰑐",
    "close": "󰅖",


    "bluetooth-on": "󰂯",
    "bluetooth-off": "󰂲",
    "bluetooth-disc": "󰂱",
    "bt-device-generic": "󰂯",
    "bt-device-headphones": "󰋋",
    "bt-device-mouse": "󰍽",
    "bt-device-keyboard": "󰌌",
    "bt-device-phone": "󰏲",
    "bt-device-watch": "󰖉",
    "bt-device-speaker": "󰓃",
    "bt-device-tv": "󰑈",
    "bt-device-controller": "󰊴",

    "volume-zero": "󰕿",
    "volume-low": "󰖀",
    "volume-high": "󰕾",
    "volume-mute": "󰝟",

    "nix": "󱄅",
    "lock": "󰍁",
    "signout": "",
    "shutdown": "󰐥",
    "reboot": "󰑙",
    "hibernate": "󰽥",

    "ethernet": "",
    "wifi-off": "󰤮",
    "signal_wifi_bad": "󰤫",
    "wifi-0": "󰤟",
    "wifi-1": "󰤢",
    "wifi-2": "󰤥",
    "wifi": "󰤨",
    "connect": "󱘖"
    
  }
}
