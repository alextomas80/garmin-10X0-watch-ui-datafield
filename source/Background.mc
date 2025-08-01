import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {
  hidden var mColor as ColorValue;
  hidden var isDarkMode = false;
  hidden var hrColor = Graphics.COLOR_LT_GRAY;

  var FIRST_ROW_HEIGHT = 0.21;
  var BASIC_ROW_HEIGHT = 0.182;

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

  function setHrColor(color as ColorValue) as Void {
    hrColor = color;
  }

  function draw(dc as Dc) as Void {
    var deviceHeight = dc.getHeight();
    var deviceWidth = dc.getWidth();

    dc.setColor(isDarkMode ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(0, 0, deviceWidth, deviceHeight);

    dc.setColor(isDarkMode ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(0, deviceHeight * 0.21, deviceWidth, deviceHeight * 0.182 + 1);

    dc.setColor(hrColor, Graphics.COLOR_TRANSPARENT);

    var inicio = deviceHeight * FIRST_ROW_HEIGHT;
    var medio = deviceWidth / 2;
    var altoPrimeraFila = deviceHeight * FIRST_ROW_HEIGHT;

    // var puntos = [
    //   [0, inicio],
    //   [medio + 8, altoPrimeraFila],
    //   [medio - 8, inicio + deviceHeight * BASIC_ROW_HEIGHT - 1],
    //   [0, inicio + deviceHeight * BASIC_ROW_HEIGHT - 1],
    // ];
    var puntos = [
      [0, inicio],
      [medio, altoPrimeraFila],
      [medio, inicio + deviceHeight * BASIC_ROW_HEIGHT - 1],
      [0, inicio + deviceHeight * BASIC_ROW_HEIGHT - 1],
    ];
    dc.fillPolygon(puntos);
  }
}
