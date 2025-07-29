import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

using DistanceGetters.Getters as DistanceUtils;

class DistanceField {
  static var _distanceValue as WatchUi.Text? = null;

  static var _lightIcon as WatchUi.Bitmap? = null;
  static var _darkIcon as WatchUi.Bitmap? = null;

  static var is8X0 as Boolean = false;

  static function draw(view as CBREdgeDashView, dc as Dc) as Void {
    var info = Activity.getActivityInfo();
    var isDarkMode = Utils.ValidationUtils.isDarkMode(view);
    var valueColor = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

    is8X0 = Utils.ValidationUtils.is8X0(dc);

    // Inicializar cache si es necesario
    initializeUICache(view);

    var elapsedDistanceValue = DistanceUtils.getElapsedDistance(info);

    updateValue(view, elapsedDistanceValue, valueColor);
    updateTimeIcon(view, isDarkMode);
  }

  hidden static function initializeUICache(view as CBREdgeDashView) as Void {
    if (_distanceValue == null) {
      _distanceValue = view.findDrawableById("distanceValue") as WatchUi.Text;
    }
    if (_lightIcon == null) {
      _lightIcon = view.findDrawableById("rulerMeasureIcon") as WatchUi.Bitmap;
    }
    if (_darkIcon == null) {
      _darkIcon = view.findDrawableById("rulerMeasureIconDark") as WatchUi.Bitmap;
    }
  }

  hidden static function updateValue(view as CBREdgeDashView, value as String, valueColor as Number) as Void {
    _distanceValue.setText(value);
    _distanceValue.setColor(valueColor);
  }

  hidden static function updateTimeIcon(view as CBREdgeDashView, isDarkMode as Boolean) as Void {
    var positionX = _distanceValue.locX + 4;
    var positionY = _distanceValue.locY;
    var offset = is8X0 ? 20 : 28;

    _lightIcon.setLocation(positionX, positionY + offset);
    _lightIcon.setVisible(!isDarkMode);
    _darkIcon.setLocation(positionX, positionY + offset);
    _darkIcon.setVisible(isDarkMode);
  }

  static function clearCache() as Void {
    _distanceValue = null;
    _lightIcon = null;
    _darkIcon = null;
  }
}
