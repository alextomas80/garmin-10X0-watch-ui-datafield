import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application.Storage;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

module DistanceGetters {
  module Getters {
    function getElapsedDistance(info as Activity.Info) as String {
      if (info has :elapsedDistance && info.elapsedDistance != null) {
        var totalDistance = info.elapsedDistance.toFloat();
        if (totalDistance < 0.0f) {
          //   return "0";
          // } else if (totalDistance < 1000.0f) {
          return totalDistance.format("%.2f");
        } else if (totalDistance < 99999.0f) {
          return (totalDistance / 1000.0f).format("%.2f");
        } else {
          return (totalDistance / 1000.0f).format("%.1f");
        }
      } else {
        return "0.00";
      }
    }
  }
}
