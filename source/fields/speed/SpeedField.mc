import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

using SpeedGetters;

class SpeedField extends WatchUi.View {
  static var _speedValue as WatchUi.Text? = null;
  static var _avgSpeedValue as WatchUi.Text? = null;
  static var _avgSpeedLabel as WatchUi.Text? = null;
  static var _maxSpeedValue as WatchUi.Text? = null;
  static var _maxSpeedLabel as WatchUi.Text? = null;

  static var _lightIcon as WatchUi.Bitmap? = null;
  static var _darkIcon as WatchUi.Bitmap? = null;

  static var UNITS_COLOR;

  function initialize() {
    View.initialize();
  }

  static function draw(view as CBREdgeDashView, valueColor as Number, isDarkMode as Boolean) as Void {
    UNITS_COLOR = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;

    var info = Activity.getActivityInfo();

    // Inicializar cache si es necesario
    initializeUICache(view);

    var speedValue = SpeedGetters.getCurrentSpeedKmH(info);
    var avgSpeedValue = SpeedGetters.getAvg(info);
    var maxSpeedValue = SpeedGetters.getMaxSpeedKmH(info);

    updateValue(_speedValue, view, speedValue, valueColor);

    // updateValue(_avgSpeedValue, view, avgSpeedValue, valueColor);
    // _avgSpeedLabel.setText("AVG");
    // _avgSpeedLabel.setColor(UNITS_COLOR);

    updateValue(_maxSpeedValue, view, maxSpeedValue, valueColor);
    _maxSpeedLabel.setText("MÁX");
    _maxSpeedLabel.setColor(UNITS_COLOR);

    updateTimeIcon(view, isDarkMode);
  }

  hidden static function initializeUICache(view as CBREdgeDashView) as Void {
    if (_speedValue == null) {
      _speedValue = view.findDrawableById("speedValue") as WatchUi.Text;
    }
    if (_avgSpeedValue == null) {
      _avgSpeedValue = view.findDrawableById("avgSpeedValue") as WatchUi.Text;
    }
    if (_avgSpeedLabel == null) {
      _avgSpeedLabel = view.findDrawableById("avgSpeedUnits") as WatchUi.Text;
    }
    if (_maxSpeedValue == null) {
      _maxSpeedValue = view.findDrawableById("maxSpeedValue") as WatchUi.Text;
    }
    if (_maxSpeedLabel == null) {
      _maxSpeedLabel = view.findDrawableById("maxSpeedUnits") as WatchUi.Text;
    }
    if (_lightIcon == null) {
      _lightIcon = view.findDrawableById("speedIcon") as WatchUi.Bitmap;
    }
    if (_darkIcon == null) {
      _darkIcon = view.findDrawableById("speedIconDark") as WatchUi.Bitmap;
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

  hidden static function updateTimeIcon(view as CBREdgeDashView, isDarkMode as Boolean) as Void {
    var positionX = _speedValue.locX + 4;
    var positionY = _speedValue.locY + 2;

    _lightIcon.setLocation(positionX, positionY);
    _lightIcon.setVisible(!isDarkMode);
    _darkIcon.setLocation(positionX, positionY);
    _darkIcon.setVisible(isDarkMode);
  }

  static function clearCache() as Void {
    _speedValue = null;
    _avgSpeedValue = null;
    _maxSpeedValue = null;
    _avgSpeedLabel = null;
    _maxSpeedLabel = null;
  }
}

//   // Avg Speed
//   var avgSpeed = info.averageSpeed;
//   averageSpeedValue = avgSpeed != null ? avgSpeed * 3.6f : 0.0f;

//   var avgSpeedLabel = View.findDrawableById("avgSpeedValue") as Text;
//   avgSpeedLabel.setText(averageSpeedValue.format("%.2f"));
//   avgSpeedLabel.setColor(VALUE_COLOR);

//   var avgUnitsLabel = View.findDrawableById("avgSpeedUnits") as Text;
//   var averageText = WatchUi.loadResource(Rez.Strings.averageText) as String;
//   avgUnitsLabel.setText(averageText);
//   avgUnitsLabel.setColor(UNITS_COLOR);

//   // Max Speed
//   var maxSpeed = info.maxSpeed;
//   maxSpeedValue = maxSpeed != null ? maxSpeed * 3.6f : 0.0f; // Convert m/s to km/h

//   var maxSpeedLabel = View.findDrawableById("maxSpeedValue") as Text;
//   maxSpeedLabel.setText(maxSpeedValue.format("%.2f"));
//   maxSpeedLabel.setColor(VALUE_COLOR);

//   var maxUnitsLabel = View.findDrawableById("maxSpeedUnits") as Text;
//   maxUnitsLabel.setText("MAX");
//   maxUnitsLabel.setColor(UNITS_COLOR);
