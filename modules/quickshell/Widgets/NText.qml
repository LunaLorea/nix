import QtQuick
import QtQuick.Layouts
import "../Commons"

Text {
  id: root

  font.pointSize: Style.fontSizeM
  font.weight: Style.fontWeightMedium
  color: Colors.mOnSurface
  elide: Text.ElideRight
  wrapMode: Text.NoWrap
  verticalAlignment: Text.AlignVCenter
}
