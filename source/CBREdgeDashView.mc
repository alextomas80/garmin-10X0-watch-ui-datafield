import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

using SensorsGetters.Getters as SensorGetters;
using DistanceGetters.Getters as DistanceUtils;
using AltitudeGetters.Getters as AltitudeUtils;
using TimeGetters.Getters as TimeUtils;

class CBREdgeDashView extends WatchUi.DataField {
  hidden var averageSpeedValue as Numeric = 0.0f;
  hidden var maxSpeedValue as Numeric = 0.0f;

  hidden var CENTER_SCREEN_PX = 141;
  hidden var HEIGHT_SCREEN = 0;
  hidden var WIDTH_SCREEN = 0;

  var font;

  var UNITS_COLOR;
  var VALUE_COLOR;

  var FIRST_ROW_HEIGHT = 0.21;
  var BASIC_ROW_HEIGHT = 0.182;

  var IS_DARK_MODE = false;

  function initialize() {
    DataField.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.MainLayout(dc));

    CENTER_SCREEN_PX = dc.getWidth() / 2;
    HEIGHT_SCREEN = dc.getHeight();
    WIDTH_SCREEN = dc.getWidth();

    font = WatchUi.loadResource(Rez.Fonts.CustomFont);
  }

  function compute(info as Activity.Info) as Void {}

  function onUpdate(dc as Dc) as Void {
    IS_DARK_MODE = getBackgroundColor() == Graphics.COLOR_BLACK;
    UNITS_COLOR = IS_DARK_MODE ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;
    VALUE_COLOR = IS_DARK_MODE ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

    (View.findDrawableById("Background") as Background).setDarkMode(IS_DARK_MODE);

    drawSpeed();
    drawHR();
    drawPower();
    drawElapsedTime();
    drawDistance();
    drawInfoRoute();
    drawElevation();
    drawFooter();

    View.onUpdate(dc);

    drawLines(dc);
    drawAppIcons(dc);
  }

  function drawLines(dc as Dc) as Void {
    dc.setPenWidth(1.5);
    dc.setColor(VALUE_COLOR, Graphics.COLOR_TRANSPARENT);

    var lines = [
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * FIRST_ROW_HEIGHT,
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * FIRST_ROW_HEIGHT,
      },
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT),
      },
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 2),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 2),
      },
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 3),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 3),
      },
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 4),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 4),
      },
      {
        // Vertical line
        :x1 => CENTER_SCREEN_PX,
        :y1 => HEIGHT_SCREEN * FIRST_ROW_HEIGHT,
        :x2 => CENTER_SCREEN_PX,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT),
      },
    ];

    for (var i = 0; i < lines.size(); i++) {
      var line = lines[i];
      dc.drawLine(line[:x1], line[:y1], line[:x2], line[:y2]);
    }
  }

  function drawSpeed() as Void {
    var info = Activity.getActivityInfo();
    var currentSpeedValue = SensorGetters.getCurrentSpeedKmH(info);

    // Current Speed
    var speedLabel = View.findDrawableById("speedValue") as Text;
    speedLabel.setText(currentSpeedValue);
    speedLabel.setColor(VALUE_COLOR);

    // Avg Speed
    var avgSpeed = info.averageSpeed;
    averageSpeedValue = avgSpeed != null ? avgSpeed * 3.6f : 0.0f;

    var avgSpeedLabel = View.findDrawableById("avgSpeedValue") as Text;
    avgSpeedLabel.setText(averageSpeedValue.format("%.2f"));
    avgSpeedLabel.setColor(VALUE_COLOR);

    var avgUnitsLabel = View.findDrawableById("avgSpeedUnits") as Text;
    var averageText = WatchUi.loadResource(Rez.Strings.averageText) as String;
    avgUnitsLabel.setText(averageText);
    avgUnitsLabel.setColor(UNITS_COLOR);

    // Max Speed
    var maxSpeed = info.maxSpeed;
    maxSpeedValue = maxSpeed != null ? maxSpeed * 3.6f : 0.0f; // Convert m/s to km/h

    var maxSpeedLabel = View.findDrawableById("maxSpeedValue") as Text;
    maxSpeedLabel.setText(maxSpeedValue.format("%.2f"));
    maxSpeedLabel.setColor(VALUE_COLOR);

    var maxUnitsLabel = View.findDrawableById("maxSpeedUnits") as Text;
    maxUnitsLabel.setText("MAX");
    maxUnitsLabel.setColor(UNITS_COLOR);
  }

  function drawHR() as Void {
    var info = Activity.getActivityInfo();

    // Current
    var currentHR = SensorGetters.getCurrentHeartRate(info);

    var hrDisplay = View.findDrawableById("heartRateValue") as Text;
    hrDisplay.setText(currentHR);
    hrDisplay.setColor(VALUE_COLOR);

    // Avg
    var avgHR = SensorGetters.getAverageHeartRate(info);

    var avgHrDisplay = View.findDrawableById("averageHeartRate") as Text;
    var averageText = WatchUi.loadResource(Rez.Strings.averageText) as String;
    avgHrDisplay.setText(averageText + " " + avgHR);
    avgHrDisplay.setColor(UNITS_COLOR);
  }

  function drawPower() as Void {
    var info = Activity.getActivityInfo();

    // Current
    var currentPowerValue = SensorGetters.getThreeSecondAveragePower(info);

    var powerDisplay = View.findDrawableById("powerValue") as Text;
    powerDisplay.setText(currentPowerValue);
    powerDisplay.setColor(VALUE_COLOR);

    // Avg
    var averagePowerValue = SensorGetters.getAveragePower(info);

    var avgPowerDisplay = View.findDrawableById("averagePower") as Text;
    var averageText = WatchUi.loadResource(Rez.Strings.averageText) as String;
    avgPowerDisplay.setText(averageText + " " + averagePowerValue);
    avgPowerDisplay.setColor(UNITS_COLOR);
  }

  function drawInfoRoute() as Void {
    var info = Activity.getActivityInfo();

    var infoRoute = SensorGetters.getInformationRoute(info);
    var valueNextPoint = infoRoute[:valueNextPoint];
    var elevationNextPoint = infoRoute[:elevationNextPoint];
    var distanceToNextPointDisplay = View.findDrawableById("distanceNextPointValue") as Text;

    if (valueNextPoint != null && valueNextPoint != 0.0f) {
      var distanceToNextPoint = valueNextPoint.format("%.2f");
      if (elevationNextPoint != null && elevationNextPoint > 0.0f) {
        distanceToNextPointDisplay.setText(distanceToNextPoint + " km · " + elevationNextPoint.format("%.0f") + "+");
      } else {
        distanceToNextPointDisplay.setText(distanceToNextPoint + " km");
      }
      distanceToNextPointDisplay.setColor(VALUE_COLOR);
    }

    var nameOfNextPointDisplay = View.findDrawableById("nameNextPointValue") as Text;
    var nameNextPoint = infoRoute[:nameNextPoint];

    if (nameNextPoint != null && nameNextPoint != "--") {
      var displayName = nameNextPoint.length() > 16 ? nameNextPoint.substring(0, 16) + "..." : nameNextPoint;
      nameOfNextPointDisplay.setText(displayName);
      nameOfNextPointDisplay.setColor(UNITS_COLOR);
    }

    // var distanceToDestinationValue = infoRoute[:valueDistanceDestination];
    // var distanceToDestinationDisplay = View.findDrawableById("distanceToDestinationValue") as Text;

    // if (distanceToDestinationValue != null && distanceToDestinationValue != 0.0f) {
    //   var distanceToDestination = distanceToDestinationValue.format("%.1f");
    //   distanceToDestinationDisplay.setText(distanceToDestination);
    //   distanceToDestinationDisplay.setColor(VALUE_COLOR);
    // }

    // var nameOfDestinationDisplay = View.findDrawableById("nameToDestinationValue") as Text;
    // var nameOfDestination = infoRoute[:nameDestination];
    // if (nameOfDestination) {
    //   nameOfDestinationDisplay.setText(nameOfDestination);
    //   nameOfDestinationDisplay.setColor(UNITS_COLOR);
    // }
  }

  function drawDistance() as Void {
    var info = Activity.getActivityInfo();

    var elapsedDistanceValue = DistanceUtils.getElapsedDistance(info);

    var distanceLabel = View.findDrawableById("distanceValue") as Text;
    distanceLabel.setText(elapsedDistanceValue);
    distanceLabel.setColor(VALUE_COLOR);
  }

  function drawElapsedTime() as Void {
    var info = Activity.getActivityInfo();

    var elapsedTime = TimeUtils.getElapsedTimeFormatted(info);
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

    var hoursDisplay = View.findDrawableById("elapsedHoursTimeValue") as Text;
    hoursDisplay.setText(hours);
    hoursDisplay.setColor(VALUE_COLOR);

    var elapsedTimeDisplay = View.findDrawableById("elapsedTimeValue") as Text;
    if (hours != "") {
      elapsedTimeDisplay.setText(minutes + ":" + seconds);
    } else {
      elapsedTimeDisplay.setText(minutes + ":" + seconds);
    }
    elapsedTimeDisplay.setColor(VALUE_COLOR);
  }

  // Función auxiliar para hacer split de strings
  function splitString(str as String, delimiter as String) as Array {
    var result = [];
    var currentStr = str;
    var delimiterIndex = currentStr.find(delimiter);

    while (delimiterIndex != null) {
      var part = currentStr.substring(0, delimiterIndex);
      result.add(part);
      currentStr = currentStr.substring(delimiterIndex + delimiter.length(), currentStr.length());
      delimiterIndex = currentStr.find(delimiter);
    }

    // Agregar la última parte si queda algo
    if (currentStr.length() > 0) {
      result.add(currentStr);
    }

    return result;
  }

  function drawElevation() as Void {
    var info = Activity.getActivityInfo();

    // Altitud
    var altitudeValue = AltitudeUtils.getAltitude(info);

    var altitudeLabel = View.findDrawableById("altitudeValue") as Text;
    altitudeLabel.setText(altitudeValue.format("%.0f"));
    altitudeLabel.setColor(VALUE_COLOR);

    // Unidades de altitud
    var altitudeUnitsLabel = View.findDrawableById("altitudeUnits") as Text;
    altitudeUnitsLabel.setText(Rez.Strings.altitudeUnits);
    altitudeUnitsLabel.setColor(UNITS_COLOR);

    // Ascento total
    var totalAscentValue = AltitudeUtils.getTotalAscent(info);

    // drawIcon(dc, Rez.Drawables.caretUp, margin, rowPosition - 18, VALUE_COLOR);
    var ascentLabel = View.findDrawableById("totalAscentValue") as Text;
    var elevationValue = totalAscentValue.format("%.0f");
    ascentLabel.setText(elevationValue);
    ascentLabel.setColor(VALUE_COLOR);

    // Descenso total
    var totalDescentValue = AltitudeUtils.getTotalDescent(info);

    // drawIcon(dc, Rez.Drawables.caretDown, margin, rowPosition + 0, VALUE_COLOR);
    var descentLabel = View.findDrawableById("totalDescentValue") as Text;
    var descentValue = totalDescentValue.format("%.0f");
    descentLabel.setText(descentValue);
    descentLabel.setColor(VALUE_COLOR);

    // Percentage
    var gradeParts = AltitudeUtils.getCurrentGradePercentageParts(info);

    var percentageGradeDisplay = View.findDrawableById("percentageGradeValue") as Text;
    percentageGradeDisplay.setText(gradeParts[:integer].format("%d"));
    percentageGradeDisplay.setColor(VALUE_COLOR);

    var percentageGradeDecimalDisplay = View.findDrawableById("percentageGradeDecimalValue") as Text;
    percentageGradeDecimalDisplay.setText(gradeParts[:decimal].format("%d"));
    percentageGradeDecimalDisplay.setColor(VALUE_COLOR);

    var point = View.findDrawableById("percentageGradePoint") as Text;
    point.setText(".");
    point.setColor(VALUE_COLOR);

    var grade = View.findDrawableById("percentageGradeUnits") as Text;
    grade.setText("%");
    grade.setColor(UNITS_COLOR);
  }

  function drawFooter() as Void {
    // Footer with current time
    var currentTime = TimeUtils.getCurrentTime();
    var battery = SensorGetters.getBattery();

    var footerText = View.findDrawableById("currentTime") as Text;
    footerText.setText(currentTime);
    footerText.setColor(VALUE_COLOR);

    var batterytext = View.findDrawableById("battery") as Text;
    batterytext.setText(battery.format("%.0f") + "%");
    batterytext.setColor(VALUE_COLOR);

    // var temperaturetext = View.findDrawableById("temperature") as Text;
    // var sensorInfo = Sensor.getInfo();
    // if (sensorInfo has :temperature && sensorInfo.temperature != null) {
    //   var temperature = sensorInfo.temperature;
    //   temperaturetext.setText(temperature.format("%.0f") + "°C");
    //   temperaturetext.setColor(VALUE_COLOR);
    // }
  }

  function drawAppIcons(dc as Dc) as Void {
    var info = Activity.getActivityInfo();
    var infoRoute = SensorGetters.getInformationRoute(info);
    var valueNextPoint = infoRoute[:valueNextPoint];

    var baseIcons = [
      {
        :resource => Rez.Drawables.heartIcon,
        :x => WIDTH_SCREEN / 2 - 30,
        :y => 107,
      },
      {
        :resource => Rez.Drawables.boltIcon,
        :x => WIDTH_SCREEN - 32,
        :y => 107,
      },
      {
        :resource => IS_DARK_MODE ? Rez.Drawables.clockDarkIcon : Rez.Drawables.clockIcon,
        :x => WIDTH_SCREEN - 32,
        :y => 313,
      },
      {
        :resource => IS_DARK_MODE ? Rez.Drawables.rulerMeasureDarkIcon : Rez.Drawables.rulerMeasureIcon,
        :x => WIDTH_SCREEN - 32,
        :y => 226,
      },
      {
        :resource => IS_DARK_MODE ? Rez.Drawables.speedDarkIcon : Rez.Drawables.speedIcon,
        :x => WIDTH_SCREEN - 32,
        :y => 53,
      },
      {
        :resource => IS_DARK_MODE ? Rez.Drawables.arrowUpDarkIcon : Rez.Drawables.arrowUpIcon,
        :x => 10,
        :y => 372,
      },
      {
        :resource => IS_DARK_MODE ? Rez.Drawables.arrowDownDarkIcon : Rez.Drawables.arrowDownIcon,
        :x => 10,
        :y => 400,
      },
    ];

    // Dibujar iconos base
    for (var i = 0; i < baseIcons.size(); i++) {
      var icon = baseIcons[i];
      drawIcon(dc, icon[:resource], icon[:x], icon[:y]);
    }

    // Solo dibujar el icono del mapa si hay información de navegación
    if (valueNextPoint != null && valueNextPoint != 0.0f) {
      var mapIcon = IS_DARK_MODE ? Rez.Drawables.mapDarkIcon : Rez.Drawables.mapIcon;
      drawIcon(dc, mapIcon, 10, 195);
    }
  }

  function drawIcon(dc as Dc, iconId as ResourceId, x as Number, y as Number) as Void {
    var icon = WatchUi.loadResource(iconId) as BitmapResource;
    dc.drawBitmap(x, y, icon);
  }
}
