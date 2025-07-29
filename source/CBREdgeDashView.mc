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
  hidden var CENTER_SCREEN_PX = 141;
  hidden var HEIGHT_SCREEN = 0;
  hidden var WIDTH_SCREEN = 0;

  static var is8X0 as Boolean = false;

  var UNITS_COLOR;
  var VALUE_COLOR;

  var FIRST_ROW_HEIGHT = 0.21;
  var BASIC_ROW_HEIGHT = 0.182;

  function initialize() {
    DataField.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.MainLayout(dc));

    CENTER_SCREEN_PX = dc.getWidth() / 2;
    HEIGHT_SCREEN = dc.getHeight();
    WIDTH_SCREEN = dc.getWidth();

    is8X0 = Utils.ValidationUtils.is8X0(dc);
  }

  function compute(info as Activity.Info) as Void {}

  function onUpdate(dc as Dc) as Void {
    var isDarkMode = Utils.ValidationUtils.isDarkMode(self);

    UNITS_COLOR = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;
    VALUE_COLOR = isDarkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

    var currentHrZone = HrGetters.getCurrentHeartRateZone(Activity.getActivityInfo());
    var currentHrZoneColor = HrGetters.getHeartRateZoneColor(currentHrZone);

    var background = View.findDrawableById("Background") as Background;
    background.setDarkMode(isDarkMode);
    background.setHrColor(currentHrZoneColor);

    View.onUpdate(dc);

    drawLines(dc);

    SpeedField.draw(self, VALUE_COLOR, isDarkMode);
    // drawHR();
    HrField.draw(self, dc);
    drawPower();
    ElapsedTimeField.draw(self, dc);
    DistanceField.draw(self, dc);
    PercentageField.draw(self, dc);
    TotalAscentField.draw(self, dc);
    TotalDescentField.draw(self, dc);
    // drawInfoRoute();

    drawFooter();
  }

  function drawLines(dc as Dc) as Void {
    var isDarkMode = Utils.ValidationUtils.isDarkMode(self);

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
        :x1 => CENTER_SCREEN_PX + 8,
        :y1 => HEIGHT_SCREEN * FIRST_ROW_HEIGHT,
        :x2 => CENTER_SCREEN_PX - 8,
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

  // function drawHR() as Void {
  //   var info = Activity.getActivityInfo();

  //   // Current
  //   var currentHR = HrGetters.getCurrentHeartRate(info);

  //   var hrDisplay = View.findDrawableById("heartRateValue") as Text;
  //   hrDisplay.setText(currentHR);
  //   hrDisplay.setColor(Graphics.COLOR_WHITE);

  //   // Icon
  //   var posHrX = hrDisplay.locX,
  //     posHrY = hrDisplay.locY,
  //     widthHr = hrDisplay.width;

  //   var hrIcon = View.findDrawableById("heartIcon") as WatchUi.Bitmap;
  //   hrIcon.setLocation(posHrX + widthHr - 5, posHrY + 5);

  //   var iconAvg2 = View.findDrawableById("circleOffIcon2") as WatchUi.Bitmap;
  //   iconAvg2.setVisible(!is8X0);

  //   if (!is8X0) {
  //     // Avg
  //     var avgHR = HrGetters.getAverageHeartRate(info);

  //     var avgHrDisplay = View.findDrawableById("averageHeartRate") as Text;
  //     avgHrDisplay.setText(avgHR);
  //     avgHrDisplay.setColor(Graphics.COLOR_WHITE);

  //     // IconAvg
  //     var positionXAvg = avgHrDisplay.locX,
  //       positionYAvg = avgHrDisplay.locY,
  //       widthHrAvg = avgHrDisplay.width,
  //       heightHrAvg = avgHrDisplay.height;

  //     iconAvg2.setLocation(positionXAvg - widthHrAvg - 30, positionYAvg - heightHrAvg / 2 + 5);
  //   }
  // }

  function drawPower() as Void {
    var info = Activity.getActivityInfo();

    // Current
    var currentPowerValue = SensorGetters.getThreeSecondAveragePower(info);

    var powerDisplay = View.findDrawableById("powerValue") as Text;
    powerDisplay.setText(currentPowerValue);
    powerDisplay.setColor(Graphics.COLOR_WHITE);

    // Icon
    var positionX = powerDisplay.locX,
      positionY = powerDisplay.locY,
      widthHr = powerDisplay.width;

    var icon = View.findDrawableById("boltIcon") as WatchUi.Bitmap;
    icon.setLocation(positionX + widthHr - 5, positionY + 5);

    var iconAvg = View.findDrawableById("circleOffIcon2") as WatchUi.Bitmap;
    iconAvg.setVisible(!is8X0);

    if (!is8X0) {
      // Avg
      var averagePowerValue = SensorGetters.getAveragePower(info);

      var avgPowerDisplay = View.findDrawableById("averagePower") as Text;
      avgPowerDisplay.setText(averagePowerValue);
      avgPowerDisplay.setColor(Graphics.COLOR_WHITE);

      // IconAvg
      var positionXAvg = avgPowerDisplay.locX,
        positionYAvg = avgPowerDisplay.locY,
        widthHrAvg = avgPowerDisplay.width,
        heightHrAvg = avgPowerDisplay.height;

      iconAvg.setLocation(positionXAvg - widthHrAvg - 30, positionYAvg - heightHrAvg / 2 + 5);
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
}
