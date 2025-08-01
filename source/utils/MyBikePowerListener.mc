using Toybox.AntPlus;
import Toybox.Activity;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
// Import or define ListItem if it's in another module

class MyBikePowerListener extends AntPlus.BikePowerListener {
  hidden enum {
    ITEM_POWER,
    ITEM_DISTANCE,
    ITEM_SPEED,
  }

  hidden const INDICATOR_HEIGHT_DISTANCE = 130;
  hidden const INDICATOR_HEIGHT_POWER = 100;
  hidden const INDICATOR_HEIGHT_SPEED = 160;

  var items;

  //! Initializes class variables
  function initialize() {
    BikePowerListener.initialize();
  }
}
