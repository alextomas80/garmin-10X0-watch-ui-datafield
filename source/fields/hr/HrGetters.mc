import Toybox.Lang;
import Toybox.Activity;
import Toybox.Graphics;

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

  function getCurrentHeartRateZone(info as Activity.Info) as Number {
    var currentHR = getCurrentHeartRate(info);
    var zones = getHeartRateZones();

    // Si no tenemos datos suficientes, retornamos null
    if (currentHR.equals("---") || zones == null || zones.size() == 0) {
      return 1;
    }

    var hrValue = currentHR.toNumber();

    for (var i = 0; i < zones.size(); i++) {
      if (hrValue <= zones[i]) {
        return i + 1; // Retornamos la zona (1-indexed)
      }
    }

    // Si está por encima de todas las zonas, está en la zona máxima
    return zones.size() + 1;
  }

  function getHeartRateZoneColor(zone as Number) as ColorValue {
    var colors = [
      Graphics.COLOR_DK_GRAY,
      Graphics.COLOR_BLUE,
      Graphics.COLOR_DK_GREEN,
      Graphics.COLOR_ORANGE,
      Graphics.COLOR_RED,
    ];

    if (zone < 1) {
      return Graphics.COLOR_DK_GRAY;
    }

    if (zone > colors.size()) {
      return Graphics.COLOR_PURPLE;
    }

    return colors[zone - 1];
  }
}
