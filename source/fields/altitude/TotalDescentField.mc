import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class TotalDescentField {
  static var _totalDescentValue as WatchUi.Text? = null;

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

    var value = Utils.NumberFormatter.formatFloat(AltitudeGetters.getTotalDescent(info), 0);
    updateValue(_totalDescentValue, view, value, valueColor);

    updateIcon(view, isDarkMode);
  }

  hidden static function initializeUICache(view as CBREdgeDashView) as Void {
    if (_totalDescentValue == null) {
      _totalDescentValue = view.findDrawableById("totalDescentValue") as WatchUi.Text;
    }

    if (_lightIcon == null) {
      _lightIcon = view.findDrawableById("arrowDownRightIcon") as WatchUi.Bitmap;
    }
    if (_darkIcon == null) {
      _darkIcon = view.findDrawableById("arrowDownRightIconDark") as WatchUi.Bitmap;
    }
  }

  hidden static function updateValue(
    field as WatchUi.Text,
    view as CBREdgeDashView,
    value as String,
    valueColor as Number
  ) as Void {
    field.setText(value);
    field.setColor(valueColor);
  }

  hidden static function updateIcon(view as CBREdgeDashView, isDarkMode as Boolean) as Void {
    var positionX = _totalDescentValue.locX - 16;
    var positionY = _totalDescentValue.locY;
    var width = _totalDescentValue.width;
    var offset = is8X0 ? -2 : 0;

    _lightIcon.setLocation(positionX - width, positionY + offset);
    _lightIcon.setVisible(!isDarkMode);
    _darkIcon.setLocation(positionX - width, positionY + offset);
    _darkIcon.setVisible(isDarkMode);
  }
}
