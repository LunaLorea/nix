pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services

Singleton {
  id: root

  // Generic workspace and window data
  property ListModel workspaces: ListModel {}
  property ListModel windows: ListModel {}
  property int focusedWindowIndex: -1

  // Generic events
  signal workspaceChanged
  signal activeWindowChanged
  signal windowListChanged

  // Backend service loader
  property var backend: null


  Loader {
    id: backendLoader
    sourceComponent: swayComponent
    onLoaded: {
      if (item) {
        root.backend = item
        setupBackendConnections()
        backend.initialize()
      }
    }
  }
  // Sway backend component
  Component {
    id: swayComponent
    SwayService {
      id: swayBackend
    }
  }

  function setupBackendConnections() {
    if (!backend)
      return

      // Connect backend signals to facade signals
      backend.workspaceChanged.connect(() => {
        // Sync workspaces when they change
        syncWorkspaces()
        // Forward the signal
        workspaceChanged()
      })

      backend.activeWindowChanged.connect(() => {
        // Sync active window when it changes
        // TODO: Avoid re-syncing all windows
        syncWindows()
        // Forward the signal
        activeWindowChanged()
      })

      backend.windowListChanged.connect(() => {
        // Sync windows when they change
        syncWindows()
        // Forward the signal
        windowListChanged()
      })

      // Property bindings
      backend.focusedWindowIndexChanged.connect(() => {
        focusedWindowIndex = backend.focusedWindowIndex
      })

      // Initial sync
      syncWorkspaces()
      syncWindows()
      focusedWindowIndex = backend.focusedWindowIndex
    }

    function syncWorkspaces() {
      workspaces.clear()
      const ws = backend.workspaces
      for (var i = 0; i < ws.count; i++) {
        workspaces.append(ws.get(i))
      }
      // Emit signal to notify listeners that workspace list has been updated
      workspacesChanged()
      Logger.log("compserv", workspaces.count)
    }

    function syncWindows() {
      windows.clear()
      const ws = backend.windows
      for (var i = 0; i < ws.length; i++) {
        windows.append(ws[i])
      }
      // Emit signal to notify listeners that workspace list has been updated
      windowListChanged()
    }

    // Get focused window
    function getFocusedWindow() {
      if (focusedWindowIndex >= 0 && focusedWindowIndex < windows.count) {
        return windows.get(focusedWindowIndex)
      }
      return null
    }

    // Get focused window title
    function getFocusedWindowTitle() {
      if (focusedWindowIndex >= 0 && focusedWindowIndex < windows.count) {
        var title = windows.get(focusedWindowIndex).title
        if (title !== undefined) {
          title = title.replace(/(\r\n|\n|\r)/g, "")
        }
        return title || ""
      }
      return ""
    }

    // Generic workspace switching
    function switchToWorkspace(workspace) {
      if (backend && backend.switchToWorkspace) {
        backend.switchToWorkspace(workspace)
      } else {
        Logger.warn("Compositor", "No backend available for workspace switching")
      }
    }

    // Get current workspace
    function getCurrentWorkspace() {
      for (var i = 0; i < workspaces.count; i++) {
        const ws = workspaces.get(i)
        if (ws.isFocused) {
          return ws
        }
      }
      return null
    }

    // Get active workspaces
    function getActiveWorkspaces() {
      const activeWorkspaces = []
      for (var i = 0; i < workspaces.count; i++) {
        const ws = workspaces.get(i)
        if (ws.isActive) {
          activeWorkspaces.push(ws)
        }
      }
      return activeWorkspaces
    }

    // Set focused window
    function focusWindow(window) {
      if (backend && backend.focusWindow) {
        backend.focusWindow(window)
      } else {
        Logger.warn("Compositor", "No backend available for window focus")
      }
    }

    // Close window
    function closeWindow(window) {
      if (backend && backend.closeWindow) {
        backend.closeWindow(window)
      } else {
        Logger.warn("Compositor", "No backend available for window closing")
      }
    }
  }
