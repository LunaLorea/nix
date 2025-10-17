import QtQuick
import Quickshell
import qs.Services
import qs.Commons

Item {
  id: root

  property string widgetId: ""
  property var widgetProps: ({})
  property string screenName: widgetProps && widgetProps.screen ? widgetProps.screen.name : ""

  implicitWidth: loader.implicitWidth
  implicitHeight: loader.implicitHeight

  Loader {
    id: loader
    active: widgetId !== ""
    sourceComponent: WidgetIdRegistry.getWidget(root.widgetId)
    onLoaded: {
      if (item && widgetProps) {
        // Apply properties to loaded widget
        for (var prop in widgetProps) {
          if (item.hasOwnProperty(prop)) {
            item[prop] = widgetProps[prop]
          }
        }
      }


      if (item.hasOwnProperty("onLoaded")) {
        item.onLoaded()
      }
    }
  }
}
