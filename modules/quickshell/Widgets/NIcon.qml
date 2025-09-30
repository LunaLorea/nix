import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Text {
  id: root

  property string icon: ""

  visible: (icon !== undefined) && (icon !== "")

  text: {
    if ((icon === undefined) || (icon == "")) {
      return Icon.get(Icon.defaultIcon)
    }
    if (Icon.get(icon) === undefined) {
      Logger.warn("Icon", `"${icon}"`, "doesn't exist in the icons font")
      Logger.callStack()
      return Icon.get(Icon.defaultIcon)
    }
    return Icon.get(icon)
  }

  color: Colors.mOnSurface
  verticalAlignment: Text.AlignVCenter
}
