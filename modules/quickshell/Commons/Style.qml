pragma Singleton

import Quickshell

Singleton {
  id: root

  /*
    Preset sizes for font, radii, ?
    */

  // Font size
  property real fontSizeXXS: 8
  property real fontSizeXS: 9
  property real fontSizeS: 10
  property real fontSizeM: 11
  property real fontSizeL: 13
  property real fontSizeXL: 16
  property real fontSizeXXL: 18
  property real fontSizeXXXL: 24

  // Font weight
  property int fontWeightRegular: 400
  property int fontWeightMedium: 500
  property int fontWeightSemiBold: 600
  property int fontWeightBold: 700

    // Radii
  property int radiusXXS: 4
  property int radiusXS: 8
  property int radiusS: 12
  property int radiusM: 16
  property int radiusL: 20

  //screen Radii
  property int screenRadius: 20

  // Border
  property int borderS: 1
  property int borderM: 2
  property int borderL: 3

  // Margins (for margins and spacing)
  property int marginXXS: 2
  property int marginXS: 4
  property int marginS: 8
  property int marginM: 12
  property int marginL: 16
  property int marginXL: 24

  // Opacity
  property real opacityNone: 0.0
  property real opacityLight: 0.25
  property real opacityMedium: 0.5
  property real opacityHeavy: 0.75
  property real opacityAlmost: 0.95
  property real opacityFull: 1.0

  property int barHeight: 38
  property int capsuleHeight: 28

  property real baseWidgetSize: 33
  property real sliderWidth: 200

  // Animation duration (ms)
  property int animationFast: 150
  property int animationNormal: 300
  property int animationSlow: 450
  property int animationSlowest: 750

  // Delays
  property int tooltipDelay: 300
  property int tooltipDelayLong: 1200
  property int pillDelay: 500

}
