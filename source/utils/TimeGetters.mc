import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application.Storage;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

module TimeGetters {
  module Getters {
    function getElapsedTime(info as Activity.Info) as Number {
      if (info has :elapsedTime && info.elapsedTime != null) {
        return info.elapsedTime / 1000; // Devuelve en milisegundos
      } else {
        return 0; // Default fallback value
      }
    }

    function getElapsedTimeFormatted(info as Activity.Info) as String {
      // Usar timerTime en lugar de elapsedTime para que respete el autopause
      var elapsedSeconds = 0;
      if (info has :timerTime && info.timerTime != null) {
        elapsedSeconds = info.timerTime / 1000; // timerTime se pausa automáticamente
      } else if (info has :elapsedTime && info.elapsedTime != null) {
        elapsedSeconds = info.elapsedTime / 1000; // Fallback si timerTime no está disponible
      }

      if (elapsedSeconds <= 0) {
        return "00:00";
      }

      var hours = elapsedSeconds / 3600;
      var minutes = (elapsedSeconds % 3600) / 60;
      var seconds = elapsedSeconds % 60;

      if (hours < 1) {
        return Lang.format("$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
      } else {
        return Lang.format("$1$:$2$:$3$", [hours.format("%01d"), minutes.format("%02d"), seconds.format("%02d")]);
      }
    }

    function getCurrentTime() as String {
      var now = Time.now();
      var info = Gregorian.info(now, Time.FORMAT_MEDIUM);

      var hour = info.hour;
      var minute = info.min;

      // Formato 24 horas
      return Lang.format("$1$:$2$", [hour.format("%02d"), minute.format("%02d")]);
    }
  }
}
