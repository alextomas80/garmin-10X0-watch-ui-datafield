import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {
  hidden var mColor as ColorValue;
  hidden var isDarkMode = false;

  function initialize() {
    var dictionary = {
      :identifier => "Background",
    };

    Drawable.initialize(dictionary);

    mColor = Graphics.COLOR_WHITE;
    isDarkMode = false;
  }

  function setColor(color as ColorValue) as Void {
    mColor = color;
  }

  function setDarkMode(darkMode) as Void {
    isDarkMode = darkMode;
  }

  function draw(dc as Dc) as Void {
    var deviceHeight = dc.getHeight();
    var deviceWidth = dc.getWidth();

    dc.setColor(isDarkMode ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(0, 0, deviceWidth, deviceHeight);

    dc.setColor(isDarkMode ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(0, deviceHeight * 0.21, deviceWidth, deviceHeight * 0.182 + 1);
  }
}
