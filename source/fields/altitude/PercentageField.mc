import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class PercentageField {
  static var _percentageValue as WatchUi.Text? = null;
  static var _percentageSymbol as WatchUi.Text? = null;

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

    var percentageValue = AltitudeGetters.getCurrentGradePercentage(info);
    var valuePercentage = Utils.NumberFormatter.formatFloat(percentageValue, 1);
    updateValue(_percentageValue, view, valuePercentage, valueColor);

    updateIcon(view, isDarkMode);
  }

  hidden static function initializeUICache(view as CBREdgeDashView) as Void {
    if (_percentageValue == null) {
      _percentageValue = view.findDrawableById("percentageGradeValue") as WatchUi.Text;
    }

    if (_percentageSymbol == null) {
      _percentageSymbol = view.findDrawableById("percentageGradeUnits") as WatchUi.Text;
    }

    if (_lightIcon == null) {
      _lightIcon = view.findDrawableById("percentageIcon") as WatchUi.Bitmap;
    }
    if (_darkIcon == null) {
      _darkIcon = view.findDrawableById("percentageIconDark") as WatchUi.Bitmap;
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
    var positionX = _percentageValue.locX + 4;
    var positionY = _percentageValue.locY;
    var offset = is8X0 ? 21 : 30;

    _lightIcon.setLocation(positionX, positionY + offset);
    _lightIcon.setVisible(!isDarkMode);
    _darkIcon.setLocation(positionX, positionY + offset);
    _darkIcon.setVisible(isDarkMode);
  }
}
