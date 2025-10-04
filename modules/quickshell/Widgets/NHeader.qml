import QtQuick
import QtQuick.Layouts
import qs.Commons

ColumnLayout {
  id: root

  property string label: ""
  property string description: ""
  property real scaling: 1.0

  spacing: Style.marginXXS * scaling
  Layout.fillWidth: true
  Layout.bottomMargin: Style.marginM * scaling

  NText {
    text: root.label
    font.pointSize: Style.fontSizeXL * scaling
    font.weight: Style.fontWeightBold
    color: Colors.mSecondary
    visible: root.label !== ""
  }

  NText {
    text: root.description
    font.pointSize: Style.fontSizeM * scaling
    color: Colors.mOnSurfaceVariant
    wrapMode: Text.WordWrap
    Layout.fillWidth: true
    visible: root.description !== ""
  }
}
