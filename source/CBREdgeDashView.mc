import Toybox.Activity;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

using SensorsGetters.Getters as SensorGetters;
using DistanceGetters.Getters as DistanceUtils;
using AltitudeGetters;
using TimeGetters.Getters as TimeUtils;
using HrGetters;

class CBREdgeDashView extends WatchUi.DataField {
  hidden const CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
  hidden var isStopped as Boolean = false;

  // Valores de la pantalla
  hidden var currentSpeed as Float = 0.0;
  hidden var avgSpeed as Float = 0.0;
  hidden var currentHr as String = "";
  hidden var currentPower as String = "";
  hidden var currentDistance as String = "";
  hidden var currentElapsedTime as String = "";
  hidden var currentPercentage as Float = 0.0;
  hidden var _currentPercentage;
  hidden var totalAscent as Float = 0.0;
  hidden var totalDescent as Float = 0.0;

  // Helpers
  hidden var IS_8X0_DEVICE as Boolean = false;
  hidden var isDarkMode as Boolean = false;
  hidden var unitsSystem as Number = System.getDeviceSettings().paceUnits;

  // Colores
  var UNITS_COLOR;
  var VALUE_COLOR;

  var FIRST_ROW_HEIGHT = 0.21;
  var BASIC_ROW_HEIGHT = 0.182;

  function initialize() {
    DataField.initialize();
  }

  function onLayout(dc as Dc) as Void {
    var settingsDevice = System.getDeviceSettings();

    setLayout(Rez.Layouts.MainLayout(dc));

    IS_8X0_DEVICE = Utils.ValidationUtils.is8X0(dc);
    unitsSystem = settingsDevice.paceUnits;

    _currentPercentage = View.findDrawableById("percentageGradeValue") as WatchUi.Text;
  }

  function compute(info as Activity.Info) as Void {
    // Current speed
    var speed = SpeedGetters.getCurrentSpeed(info);
    if (unitsSystem == System.UNIT_STATUTE) {
      currentSpeed = speed * 2.237;
    } else {
      currentSpeed = speed * 3.6;
    }

    // Avg Speed
    var avg = SpeedGetters.getAvg(info);
    if (unitsSystem == System.UNIT_STATUTE) {
      avgSpeed = avg * 2.237;
    } else {
      avgSpeed = avg * 3.6;
    }

    // HR
    currentHr = HrGetters.getCurrentHeartRate(info);

    // Power Watts
    currentPower = SensorGetters.getThreeSecondAveragePower(info);

    // Distance
    currentDistance = DistanceGetters.Getters.getElapsedDistance(info);

    // Elapsed Time
    currentElapsedTime = TimeGetters.Getters.getElapsedTimeFormatted(info);

    // Percentage
    currentPercentage = AltitudeGetters.getCurrentGradePercentage(info);

    // Ascent and Descent
    totalAscent = AltitudeGetters.getTotalAscent(info);
    totalDescent = AltitudeGetters.getTotalDescent(info);
  }

  function onUpdate(dc as Dc) as Void {
    var backgroundColor = getBackgroundColor();
    isDarkMode = backgroundColor == Graphics.COLOR_BLACK;

    // - INICIO --- Actualizar colores del fondo
    var background = View.findDrawableById("Background") as Background;
    background.setDarkMode(isDarkMode);

    var currentHrZone = HrGetters.getCurrentHeartRateZone(Activity.getActivityInfo());
    var currentHrZoneColor = HrGetters.getHeartRateZoneColor(currentHrZone);
    background.setHrColor(currentHrZoneColor);
    // - FIN --- Actualizar colores del fondo

    UNITS_COLOR = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;
    VALUE_COLOR = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

    drawAvgSpeed();
    drawHr();
    drawPower();
    drawDistance();
    drawElapsedTime();
    drawPercentage();
    drawAscentAndDescent();
    drawFooter();

    View.onUpdate(dc);

    drawCurrentSpeed(dc);
    drawLines(dc);
    drawAppIcons(dc);
  }

  function onTimerStart() as Void {
    System.println("Start!");
    isStopped = false;
  }

  function onTimerStop() as Void {
    System.println("Stop!");
    isStopped = true;
  }

  function onTimerPause() as Void {
    System.println("Stop!!!");
    isStopped = true;
  }

  function drawLines(dc as Dc) as Void {
    var CENTER_SCREEN_PX = dc.getWidth() / 2;
    var HEIGHT_SCREEN = dc.getHeight();
    var WIDTH_SCREEN = dc.getWidth();

    var lines = [
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 2),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 2),
        :color => VALUE_COLOR,
        :width => 1.5,
      },
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 3),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 3),
        :color => VALUE_COLOR,
        :width => 1.5,
      },
      {
        :x1 => 0,
        :y1 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 4),
        :x2 => WIDTH_SCREEN,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT * 4),
        :color => VALUE_COLOR,
        :width => 1.5,
      },
      {
        // Vertical line
        :x1 => CENTER_SCREEN_PX,
        :y1 => HEIGHT_SCREEN * FIRST_ROW_HEIGHT,
        :x2 => CENTER_SCREEN_PX,
        :y2 => HEIGHT_SCREEN * (FIRST_ROW_HEIGHT + BASIC_ROW_HEIGHT),
        :color => isDarkMode ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE,
        :width => 4,
      },
    ];

    for (var i = 0; i < lines.size(); i++) {
      var line = lines[i];
      dc.setColor(line[:color], Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(line[:width]);
      dc.drawLine(line[:x1], line[:y1], line[:x2], line[:y2]);
    }
  }

  function drawInfoRoute() as Void {
    var info = Activity.getActivityInfo();

    var infoRoute = SensorGetters.getInformationRoute(info);
    var valueNextPoint = infoRoute[:valueNextPoint];
    var distanceToNextPointDisplay = View.findDrawableById("distanceNextPointValue") as Text;

    if (valueNextPoint != null && valueNextPoint != 0.0f) {
      var distanceToNextPoint = valueNextPoint.format("%.2f");
      distanceToNextPointDisplay.setText(distanceToNextPoint + " km");
      distanceToNextPointDisplay.setColor(VALUE_COLOR);
    }

    var nameOfNextPointDisplay = View.findDrawableById("nameNextPointValue") as Text;
    var nameNextPoint = infoRoute[:nameNextPoint];

    if (nameNextPoint != null && nameNextPoint != "--") {
      var displayName = nameNextPoint.length() > 13 ? nameNextPoint.substring(0, 13) + "..." : nameNextPoint;
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

    // Custom bottom text
    var customBottomText = Application.Properties.getValue("CustomBottomText") as String;
    if (customBottomText.length() > 0) {
      var customTextLabel = View.findDrawableById("customUserBottomText") as Text;
      customTextLabel.setText(customBottomText);
      customTextLabel.setColor(VALUE_COLOR);
    }

    // Custom top text
    var customTopText = Application.Properties.getValue("CustomTopText") as String;
    if (customTopText.length() > 0) {
      var customTopTextLabel = View.findDrawableById("customUserTopText") as Text;
      customTopTextLabel.setText(customTopText);
      customTopTextLabel.setColor(VALUE_COLOR);
    }
  }

  function drawCurrentSpeed(dc as Dc) as Void {
    var _currentSpeedId = View.findDrawableById("speedValue") as WatchUi.Text;
    _currentSpeedId.setText(currentSpeed.format("%0.1f"));
    _currentSpeedId.setColor(VALUE_COLOR);

    var _currentSpeedLabelId = View.findDrawableById("speed_label") as WatchUi.Text;
    _currentSpeedLabelId.setText(unitsSystem == System.UNIT_STATUTE ? " mph" : " km/h");
    _currentSpeedLabelId.setColor(UNITS_COLOR);

    var icon;
    if (currentSpeed > avgSpeed) {
      icon = isDarkMode ? WatchUi.loadResource(Rez.Drawables.caretUpDark) : WatchUi.loadResource(Rez.Drawables.caretUp);
    } else {
      icon = isDarkMode
        ? WatchUi.loadResource(Rez.Drawables.caretDownDark)
        : WatchUi.loadResource(Rez.Drawables.caretDown);
    }
    if (avgSpeed > 0) {
      var positionX = IS_8X0_DEVICE ? 213 : 249;
      var positionY = IS_8X0_DEVICE ? 4 : 21;
      dc.drawBitmap(positionX, positionY, icon);
    }
  }

  function drawAvgSpeed() as Void {
    var _avgSpeedId = View.findDrawableById("avgSpeedValue") as WatchUi.Text;
    _avgSpeedId.setText(avgSpeed.format("%0.2f") + (unitsSystem == System.UNIT_STATUTE ? " mph" : " km/h"));
    _avgSpeedId.setColor(VALUE_COLOR);

    var _avgSpeedLabelId = View.findDrawableById("avgSpeedLabel") as WatchUi.Text;
    _avgSpeedLabelId.setText("AVG");
    _avgSpeedLabelId.setColor(UNITS_COLOR);
  }

  function drawHr() as Void {
    var _hrId = View.findDrawableById("hrValue") as WatchUi.Text;
    _hrId.setText(currentHr);
    _hrId.setColor(Graphics.COLOR_WHITE);
  }

  function drawPower() as Void {
    var _powerId = View.findDrawableById("powerValue") as WatchUi.Text;
    _powerId.setText(currentPower);
    _powerId.setColor(Graphics.COLOR_WHITE);
  }

  function drawDistance() as Void {
    var _distanceId = View.findDrawableById("distanceValue") as WatchUi.Text;
    _distanceId.setText(currentDistance);
    _distanceId.setColor(VALUE_COLOR);

    var _distanceLabelId = View.findDrawableById("distance_label") as WatchUi.Text;
    _distanceLabelId.setColor(VALUE_COLOR);
  }

  function drawElapsedTime() as Void {
    var _elapsedTimeId = View.findDrawableById("elapsedTimeValue") as WatchUi.Text;
    _elapsedTimeId.setText(currentElapsedTime);
    _elapsedTimeId.setColor(VALUE_COLOR);
  }

  function drawPercentage() as Void {
    if (isStopped) {
      _currentPercentage.setText("0.0");
      _currentPercentage.setColor(VALUE_COLOR);
      return;
    }
    var percentageFormatted = Utils.NumberFormatter.formatFloat(currentPercentage, 1);
    _currentPercentage.setText(percentageFormatted);
    _currentPercentage.setColor(VALUE_COLOR);
  }

  function drawAscentAndDescent() as Void {
    var ascentId = View.findDrawableById("totalAscentValue") as WatchUi.Text;
    ascentId.setText(Utils.NumberFormatter.formatFloat(totalAscent, 0) + " m");
    ascentId.setColor(VALUE_COLOR);

    var descentId = View.findDrawableById("totalDescentValue") as WatchUi.Text;
    descentId.setText(Utils.NumberFormatter.formatFloat(totalDescent, 0) + " m");
    descentId.setColor(VALUE_COLOR);
  }

  function drawAppIcons(dc as Dc) as Void {
    var WIDTH_SCREEN = dc.getWidth();

    var baseIcons = [
      {
        :resource => Rez.Drawables.heartIcon,
        :x => IS_8X0_DEVICE ? 95 : 108,
        :y => IS_8X0_DEVICE ? 88 : 140,
      },
      {
        :resource => Rez.Drawables.boltIcon,
        :x => IS_8X0_DEVICE ? WIDTH_SCREEN - 32 : 250,
        :y => IS_8X0_DEVICE ? 87 : 139,
      },
      {
        :resource => isDarkMode ? Rez.Drawables.clockDarkIcon : Rez.Drawables.clockIcon,
        :x => WIDTH_SCREEN - 34,
        :y => IS_8X0_DEVICE ? 209 : 311,
      },
      {
        :resource => isDarkMode ? Rez.Drawables.rulerMeasureDarkIcon : Rez.Drawables.rulerMeasureIcon,
        :x => WIDTH_SCREEN - 34,
        :y => IS_8X0_DEVICE ? 151 : 226,
      },
      {
        :resource => isDarkMode ? Rez.Drawables.percentageIconDark : Rez.Drawables.percentageIcon,
        :x => WIDTH_SCREEN - 34,
        :y => IS_8X0_DEVICE ? 269 : 397,
      },
      {
        :resource => isDarkMode ? Rez.Drawables.speedDarkIcon : Rez.Drawables.speedIcon,
        :x => WIDTH_SCREEN - 33,
        :y => IS_8X0_DEVICE ? 32 : 40,
      },
      {
        :resource => isDarkMode ? Rez.Drawables.arrowUpDarkIcon : Rez.Drawables.arrowUpIcon,
        :x => 15,
        :y => IS_8X0_DEVICE ? 249 : 372,
      },
      {
        :resource => isDarkMode ? Rez.Drawables.arrowDownDarkIcon : Rez.Drawables.arrowDownIcon,
        :x => 15,
        :y => IS_8X0_DEVICE ? 273 : 400,
      },
    ];

    for (var i = 0; i < baseIcons.size(); i++) {
      var icon = baseIcons[i];
      drawIcon(dc, icon[:resource], icon[:x], icon[:y]);
    }
  }

  function drawIcon(dc as Dc, iconId as ResourceId, x as Number, y as Number) as Void {
    var icon = WatchUi.loadResource(iconId) as BitmapResource;
    dc.drawBitmap(x, y, icon);
  }
}
