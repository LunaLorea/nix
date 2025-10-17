pragma Singleton

import QtQuick
import Quickshell
import qs.Commons

Singleton {
  id: root

  // Cache for current scales - updated via signals
  property var currentMonitors: ({})

  Component.onCompleted: {
    onSettingsLoaded()
    Logger.log("Scaling", "Service started")
  }


  function onSettingsLoaded() {
    // Initialize cache from Settings once they are loaded on startup
    var monitors = Settings.monitors || []
    for (var i = 0; i < monitors.length; i++) {
      if (monitors[i].name && monitors[i].scale !== undefined) {
        currentMonitors[monitors[i].name] = {
          scale: monitors[i].scale / 4.5,
          showBar: monitors[i].showBar,
          barPosition: monitors[i].barPosition,
          barWidgets: monitors[i].barWidgets
        }
        Logger.log("ScreenService", "Caching settings for", monitors[i].name, ":", monitors[i].scale)
      }
    }
  }


  // -------------------------------------------
  // get bar position status for screen
  function getScreenBarPosition(aScreen) {
    try {
      if (aScreen !== undefined && aScreen.name !== undefined) {
        return getScreenBarPositionByName(aScreen.name)
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return "top"
  }

  // -------------------------------------------
  // Get bar position status from cache
  function getScreenBarPositionByName(aScreenName) {
    try {
      var barPosition = currentMonitors["*"].barPosition
      if ( currentMonitors[aScreenName] !== undefined ) {
        barPosition = currentMonitors[aScreenName].barPosition
      }
      if ((barPosition !== undefined) && (barPosition != null)) {
        return barPosition
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return "top"
  }
  // -------------------------------------------
  // get bar show status for screen
  function getScreenShowBar(aScreen) {
    try {
      if (aScreen !== undefined && aScreen.name !== undefined) {
        return getScreenShowBarByName(aScreen.name)
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return true
  }

  // -------------------------------------------
  // Get showbar status from cache
  function getScreenShowBarByName(aScreenName) {
    try {
      var showBar = currentMonitors["*"].showBar
      if ( currentMonitors[aScreenName] !== undefined ) {
        showBar = currentMonitors[aScreenName].showBar
      }
      if ((showBar !== undefined) && (showBar != null)) {
        return showBar
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return true
  }
  // -------------------------------------------
  // Manual scaling via Settings
  function getScreenScale(aScreen) {
    try {
      if (aScreen !== undefined && aScreen.name !== undefined) {
        var scale = getScreenScaleByName(aScreen.name) * aScreen.physicalPixelDensity
        return scale
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return 1.0
  }

  // -------------------------------------------
  // Get scale from cache for better performance
  function getScreenScaleByName(aScreenName) {
    try {
      var scale = currentMonitors["*"].scale
      if (currentMonitors[aScreenName] !== undefined) {
        scale = currentMonitors[aScreenName].scale
      }
      if ((scale !== undefined) && (scale != null)) {
        return scale
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return 1.0
  }
  // -------------------------------------------
  // get bar widget status for screen
  function getScreenBarWidgets(aScreen, section) {
    try {
      if (aScreen !== undefined && aScreen.name !== undefined) {
        return getScreenBarWidgetsByName(aScreen.name, section)
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return "top"
  }

  // -------------------------------------------
  // Get bar position status from cache
  function getScreenBarWidgetsByName(aScreenName, section) {
    try {
      var widgets = currentMonitors["*"].barWidgets
      if ( currentMonitors[aScreenName] !== undefined ) {
        widgets = currentMonitors[aScreenName].barWidgets
      }
      if ((widgets !== undefined) && (widgets != null)) {
        if (section == "left") {
          return widgets.left
        } else if (section == "middle") {
          return widgets.middle
        } else if (section == "right") {
          return widgets.right
        }
      }
    } catch (e) {

      //Logger.warn(e)
    }
    return []
  }
}
