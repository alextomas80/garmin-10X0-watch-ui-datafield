import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

class HrField {
  static var _hrValue as WatchUi.Text? = null;
  static var _avgHRValue as WatchUi.Text? = null;

  static var _heartIcon as WatchUi.Bitmap? = null;
  static var _avgIcon as WatchUi.Bitmap? = null;

  static var is8X0 as Boolean = false;

  static function draw(view as CBREdgeDashView, dc as Dc) as Void {
    var info = Activity.getActivityInfo();
    var isDarkMode = Utils.ValidationUtils.isDarkMode(view);
    var valueColor = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

    is8X0 = Utils.ValidationUtils.is8X0(dc);

    // Inicializar cache si es necesario
    initializeUICache(view);

    var value = HrGetters.getCurrentHeartRate(info);
    updateValue(_hrValue, view, value, valueColor);

    if (is8X0) {
      _avgHRValue.setVisible(false);
    } else {
      var avgValue = HrGetters.getAverageHeartRate(info);
      updateValue(_avgHRValue, view, avgValue, valueColor);
      _avgHRValue.setVisible(true);
    }

    updateIcon();
  }

  hidden static function initializeUICache(view as CBREdgeDashView) as Void {
    if (_hrValue == null) {
      _hrValue = view.findDrawableById("heartRateValue") as WatchUi.Text;
    }
    if (_avgHRValue == null) {
      _avgHRValue = view.findDrawableById("averageHeartRate") as WatchUi.Text;
    }
    if (_heartIcon == null) {
      _heartIcon = view.findDrawableById("heartIcon") as WatchUi.Bitmap;
    }
    if (_avgIcon == null) {
      _avgIcon = view.findDrawableById("circleOffIcon1") as WatchUi.Bitmap;
    }
  }

  hidden static function updateValue(
    field as WatchUi.Text,
    view as CBREdgeDashView,
    value as String,
    valueColor as Number
  ) as Void {
    field.setText(value);
    field.setColor(Graphics.COLOR_WHITE);
  }

  hidden static function updateIcon() as Void {
    var positionX = _hrValue.locX + 4;
    var positionY = _hrValue.locY + 2;
    var width = _hrValue.width;

    _heartIcon.setLocation(positionX + width - 5, positionY + 5);
    _avgIcon.setVisible(!is8X0);

    if (!is8X0) {
      var positionXAvg = _avgHRValue.locX;
      var positionYAvg = _avgHRValue.locY;
      var widthHrAvg = _avgHRValue.width;
      var heightHrAvg = _avgHRValue.height;

      _avgIcon.setLocation(positionXAvg - widthHrAvg - 30, positionYAvg - heightHrAvg / 2 + 5);
      _avgIcon.setVisible(true);
    }
  }
}
