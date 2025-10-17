import QtQuick
import QtQuick.Layouts
import "../Commons"

Text {
  id: root

  property real scaling: 1.0

  font.pointSize: Style.fontSizeM * scaling
  font.weight: Style.fontWeightMedium
  color: Colors.mOnSurface
  elide: Text.ElideRight
  wrapMode: Text.NoWrap
  verticalAlignment: Text.AlignVCenter
}
