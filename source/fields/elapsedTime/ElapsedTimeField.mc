import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

using TimeGetters.Getters as TimeUtils;

class ElapsedTimeField {
  static var _lightIcon as WatchUi.Bitmap? = null;
  static var _darkIcon as WatchUi.Bitmap? = null;

  static var is8X0 as Boolean = false;

  static function draw(view as CBREdgeDashView, dc as Dc) as Void {
    var info = Activity.getActivityInfo();
    var isDarkMode = Utils.ValidationUtils.isDarkMode(view);
    var valueColor = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

    var elapsedTime = TimeUtils.getElapsedTimeFormatted(info);

    is8X0 = Utils.ValidationUtils.is8X0(dc);

    // Inicializar cache si es necesario
    initializeUICache(view);

    var timeParts = parseElapsedTime(elapsedTime);

    updateTimeDisplays(view, timeParts, valueColor);
    updateTimeIcon(view, timeParts[:elapsedTimeDisplay], isDarkMode);
  }

  hidden static function initializeUICache(view as CBREdgeDashView) as Void {
    if (_lightIcon == null) {
      _lightIcon = view.findDrawableById("clockIcon") as WatchUi.Bitmap;
    }
    if (_darkIcon == null) {
      _darkIcon = view.findDrawableById("clockIconDark") as WatchUi.Bitmap;
    }
  }

  hidden static function parseElapsedTime(elapsedTime as String) as Dictionary {
    var splitTime = splitString(elapsedTime, ":");
    var hours = "";
    var minutes = "";
    var seconds = "";

    if (splitTime.size() == 2) {
      // Formato MM:SS
      minutes = splitTime[0];
      seconds = splitTime[1];
    } else if (splitTime.size() == 3) {
      // Formato HH:MM:SS
      hours = splitTime[0];
      minutes = splitTime[1];
      seconds = splitTime[2];
    }

    return {
      :hours => hours,
      :minutes => minutes,
      :seconds => seconds,
      :formattedTime => minutes + ":" + seconds,
    };
  }

  hidden static function updateTimeDisplays(
    view as CBREdgeDashView,
    timeParts as Dictionary,
    valueColor as Number
  ) as Void {
    // Update hours display
    var hoursDisplay = view.findDrawableById("elapsedHoursTimeValue") as Text;
    hoursDisplay.setText(timeParts[:hours]);
    hoursDisplay.setColor(valueColor);

    // Update minutes:seconds display
    var elapsedTimeDisplay = view.findDrawableById("elapsedTimeValue") as Text;
    elapsedTimeDisplay.setText(timeParts[:formattedTime]);
    elapsedTimeDisplay.setColor(valueColor);

    // Store reference for icon positioning
    timeParts[:elapsedTimeDisplay] = elapsedTimeDisplay;
  }

  hidden static function updateTimeIcon(
    view as CBREdgeDashView,
    elapsedTimeDisplay as Text,
    isDarkMode as Boolean
  ) as Void {
    var positionX = elapsedTimeDisplay.locX + 4;
    var positionY = elapsedTimeDisplay.locY;
    var offset = is8X0 ? 20 : 29;

    _lightIcon.setLocation(positionX, positionY + offset);
    _lightIcon.setVisible(!isDarkMode);
    _darkIcon.setLocation(positionX, positionY + offset);
    _darkIcon.setVisible(isDarkMode);
  }

  hidden static function splitString(str as String, delimiter as String) as Array {
    var result = [];
    var currentStr = str;
    var delimiterIndex = currentStr.find(delimiter);

    while (delimiterIndex != null) {
      var part = currentStr.substring(0, delimiterIndex);
      result.add(part);
      currentStr = currentStr.substring(delimiterIndex + delimiter.length(), currentStr.length());
      delimiterIndex = currentStr.find(delimiter);
    }

    if (currentStr.length() > 0) {
      result.add(currentStr);
    }

    return result;
  }

  static function clearCache() as Void {
    _lightIcon = null;
    _darkIcon = null;
  }
}
