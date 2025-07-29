import Toybox.Lang;
import Toybox.Activity;

const MS_TO_KMH_FACTOR = 3.6f;
const DECIMAL_PRECISION = 10;
const DEFAULT_SPEED = "0.0";
const DEFAULT_AVG_SPEED = "0.00";

module SpeedGetters {
  function getCurrentSpeedKmH(info as Activity.Info) as String {
    if (info has :currentSpeed && info.currentSpeed != null) {
      var speedKmH = info.currentSpeed * MS_TO_KMH_FACTOR;
      var intPart = speedKmH.toNumber();
      var decimalPart = ((speedKmH - intPart) * DECIMAL_PRECISION).toNumber();
      return intPart.toString() + "." + decimalPart.toString();
    } else {
      return DEFAULT_SPEED;
    }
  }

  function getAvg(info as Activity.Info) as String {
    if (info has :averageSpeed && info.averageSpeed != null) {
      var avgKmH = info.averageSpeed * MS_TO_KMH_FACTOR;

      // Formatear con 2 decimales
      var intPart = avgKmH.toNumber();
      var decimalPart = ((avgKmH - intPart) * 100).toNumber();

      // Asegurar que el decimal esté en rango 0-99
      decimalPart = decimalPart % 100;

      // Formatear el decimal con ceros a la izquierda si es necesario
      var decimalStr = decimalPart.toString();
      if (decimalPart < 10) {
        decimalStr = "0" + decimalStr;
      }

      return intPart.toString() + "." + decimalStr;
    } else {
      return DEFAULT_AVG_SPEED;
    }
  }

  function getMaxSpeedKmH(info as Activity.Info) as String {
    if (info has :maxSpeed && info.maxSpeed != null) {
      var maxSpeedKmH = info.maxSpeed * MS_TO_KMH_FACTOR;

      // Formatear con 2 decimales
      var intPart = maxSpeedKmH.toNumber();
      var decimalPart = ((maxSpeedKmH - intPart) * 100).toNumber();

      // Asegurar que el decimal esté en rango 0-99
      decimalPart = decimalPart % 100;

      // Formatear el decimal con ceros a la izquierda si es necesario
      var decimalStr = decimalPart.toString();
      if (decimalPart < 10) {
        decimalStr = "0" + decimalStr;
      }

      return intPart.toString() + "." + decimalStr;
    } else {
      return DEFAULT_AVG_SPEED;
    }
  }
}
