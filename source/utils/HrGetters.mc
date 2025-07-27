import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application.Storage;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;
using Toybox.UserProfile;

module HrGetters {
  function getCurrentHeartRate(info as Activity.Info) as String {
    if (info has :currentHeartRate && info.currentHeartRate != null) {
      return info.currentHeartRate.toFloat().format("%d");
    } else {
      return "---";
    }
  }

  function getAverageHeartRate(info as Activity.Info) as String {
    if (info has :averageHeartRate && info.averageHeartRate != null) {
      return info.averageHeartRate.toFloat().format("%d");
    } else {
      return "---";
    }
  }

  function getHeartRateZones() as Array<Number>? {
    var heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);

    if (heartRateZones.size() > 0) {
      return heartRateZones;
    } else {
      return null;
    }
  }

  function getCurrentHeartRateZone(info as Activity.Info) as Number? {
    var currentHR = getCurrentHeartRate(info);
    var zones = getHeartRateZones();

    // Si no tenemos datos suficientes, retornamos null
    if (currentHR.equals("---") || zones == null || zones.size() == 0) {
      return null;
    }

    var hrValue = currentHR.toNumber();

    // Las zonas suelen estar ordenadas de menor a mayor
    // Zona 1: Hasta zones[0]
    // Zona 2: zones[0] a zones[1]
    // Zona 3: zones[1] a zones[2]
    // etc.

    for (var i = 0; i < zones.size(); i++) {
      if (hrValue <= zones[i]) {
        return i + 1; // Retornamos la zona (1-indexed)
      }
    }

    // Si está por encima de todas las zonas, está en la zona máxima
    return zones.size() + 1;
  }

  function getHeartRateZonePercentage(info as Activity.Info) as String {
    var currentHR = getCurrentHeartRate(info);
    var zones = getHeartRateZones();
    var currentZone = getCurrentHeartRateZone(info);

    if (currentHR.equals("---") || zones == null || currentZone == null) {
      return "---";
    }

    var hrValue = currentHR.toNumber();
    var percentage = 0.0f;

    if (currentZone == 1) {
      // Zona 1: desde 0 hasta zones[0]
      percentage = (hrValue.toFloat() / zones[0].toFloat()) * 100.0f;
    } else if (currentZone <= zones.size()) {
      // Zonas intermedias
      var lowerBound = zones[currentZone - 2];
      var upperBound = zones[currentZone - 1];
      percentage =
        ((hrValue.toFloat() - lowerBound.toFloat()) / (upperBound.toFloat() - lowerBound.toFloat())) * 100.0f;
    } else {
      // Por encima de la zona máxima
      percentage = 100.0f;
    }

    return percentage.format("%.0f") + "%";
  }
}
