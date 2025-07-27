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

module SensorsGetters {
  module Getters {
    // function getNone() as Null {
    //   return null;
    // }

    // function getSteps() as Number? {
    //   return ActivityMonitor.getInfo().steps;
    // }

    // function getCalories() as Number? {
    //   return ActivityMonitor.getInfo().calories;
    // }

    // function getStressScore() as Number? {
    //   return ActivityMonitor.getInfo().stressScore;
    // }

    // function getFloors() as Number? {
    //   return ActivityMonitor.getInfo().floorsClimbed;
    // }

    // function getTimeToRecovery() as Number? {
    //   return ActivityMonitor.getInfo().timeToRecovery;
    // }

    // function getStepGoal() as Number? {
    //   return ActivityMonitor.getInfo().stepGoal;
    // }

    // function getRespirationRate() as Number? {
    //   return ActivityMonitor.getInfo().respirationRate;
    // }

    // function getMetersClimbed() as Float? {
    //   return ActivityMonitor.getInfo().metersClimbed;
    // }

    // function getFloorsClimbedGoal() as Number? {
    //   return ActivityMonitor.getInfo().floorsClimbedGoal;
    // }

    // function getDistanceMeters() as Float? {
    //   var distanceCm = ActivityMonitor.getInfo().distance;

    //   return distanceCm != null ? distanceCm.toFloat() / 100 : null;
    // }

    // function getActiveMinutesDay() as Number? {
    //   var value = ActivityMonitor.getInfo().activeMinutesDay;

    //   return value != null ? value.total : value;
    // }

    // function getMemory() as Number {
    //   return System.getSystemStats().usedMemory;
    // }

    function getBattery() as Number {
      return System.getSystemStats().battery.toNumber();
    }

    // function getBatteryInDays() as Number {
    //   return System.getSystemStats().batteryInDays.toNumber();
    // }

    // function getAlarmCount() as Number {
    //   return System.getDeviceSettings().alarmCount;
    // }

    // function getMessages() as Number {
    //   return System.getDeviceSettings().notificationCount;
    // }

    // function getSolarIntensity() as Number? {
    //   return System.getSystemStats().solarIntensity;
    // }

    // function isDoNotDisturb() as Boolean? {
    //   return System.getDeviceSettings().doNotDisturb;
    // }

    // function isNightModeEnabled() as Boolean {
    //   return !!System.getDeviceSettings().isNightModeEnabled;
    // }

    // function getIsConnected() as Boolean {
    //   return System.getDeviceSettings().phoneConnected;
    // }

    // function getActiveMinutesWeek() as Number? {
    //   var value = ActivityMonitor.getInfo().activeMinutesWeek;

    //   return value != null ? value.total : null;
    // }

    function getActiveMinutesWeekGoal() as Number? {
      return ActivityMonitor.getInfo().activeMinutesWeekGoal;
    }

    // Activity-specific getters for CBR Edge Dash
    function getCurrentSpeedKmH(info as Activity.Info) as String {
      if (info has :currentSpeed && info.currentSpeed != null) {
        var speedKmH = info.currentSpeed * 3.6f;
        var intPart = speedKmH.toNumber();
        var decimalPart = ((speedKmH - intPart) * 10).toNumber();
        return intPart.toString() + "." + decimalPart.toString();
      } else {
        return "0.0";
      }
    }

    // Helper function to format speed with comma as decimal separator
    function formatSpeedWithComma(speed as Float) as String {
      var intPart = speed.toNumber();
      var decimalPart = ((speed - intPart) * 10).toNumber();
      return intPart.toString() + "," + decimalPart.toString();
    }

    function getMaxDistance(info as Activity.Info) as Float {
      // Try all available distance sources and use the largest value
      var distanceInMeters = 0.0f;
      var maxDistance = 0.0f;

      // Check elapsedDistance
      if (info has :elapsedDistance && info.elapsedDistance != null) {
        distanceInMeters = info.elapsedDistance;
        if (distanceInMeters > maxDistance) {
          maxDistance = distanceInMeters;
        }
      }

      // Check totalDistance
      if (info has :totalDistance && info.totalDistance != null) {
        distanceInMeters = info.totalDistance;
        if (distanceInMeters > maxDistance) {
          maxDistance = distanceInMeters;
        }
      }

      // Check distance
      if (info has :distance && info.distance != null) {
        distanceInMeters = info.distance;
        if (distanceInMeters > maxDistance) {
          maxDistance = distanceInMeters;
        }
      }

      // Convert from meters to kilometers
      var distanceKm = maxDistance / 1000.0f;
      return distanceKm;
    }

    function getCurrentPower(info as Activity.Info) as Float {
      if (info has :currentPower && info.currentPower != null) {
        return info.currentPower.toFloat();
      } else {
        return 0.0f;
      }
    }

    function getInformationRoute(info as Activity.Info) as Dictionary {
      var valueDistanceDestination;
      var nameDestination;
      var valueNextPoint;
      var nameNextPoint;
      var elevationNextPoint;

      if (info has :distanceToDestination && info.distanceToDestination != null) {
        valueDistanceDestination = info.distanceToDestination.toFloat() / 1000.0f;
      } else {
        valueDistanceDestination = null;
      }

      if (info has :nameOfDestination && info.nameOfDestination != null) {
        nameDestination = info.nameOfDestination.toString();
      } else {
        nameDestination = null;
      }

      if (info has :distanceToNextPoint && info.distanceToNextPoint != null) {
        valueNextPoint = info.distanceToNextPoint.toFloat() / 1000.0f;
      } else {
        valueNextPoint = null;
      }

      if (info has :nameOfNextPoint && info.nameOfNextPoint != null) {
        nameNextPoint = info.nameOfNextPoint.toString();
      } else {
        nameNextPoint = null;
      }

      if (info has :elevationAtNextPoint && info.elevationAtNextPoint != null) {
        elevationNextPoint = info.elevationAtNextPoint.toFloat();
      } else {
        elevationNextPoint = null;
      }

      return {
        :valueDistanceDestination => valueDistanceDestination,
        :nameDestination => nameDestination,
        :valueNextPoint => valueNextPoint,
        :nameNextPoint => nameNextPoint,
        :elevationNextPoint => elevationNextPoint,
      };
    }

    function getDistance(info as Activity.Info) as Float {
      if (info has :distance && info.distance != null) {
        return info.distance.toFloat() / 1000.0f; // Convert from cm to km
      } else {
        return 0.0f; // Default fallback value
      }
    }

    function getThreeSecondAveragePower(info as Activity.Info) as String {
      // Calcula la potencia promedio de los últimos 3 segundos
      // Usando una implementación simplificada basada en potencia actual y histórica

      var currentPower = getCurrentPower(info);

      if (currentPower <= 0) {
        return "---";
      }

      // Intentar obtener potencia promedio si está disponible como referencia
      var averagePower = 0.0f;
      if (info has :averagePower && info.averagePower != null) {
        averagePower = info.averagePower.toFloat();
      }

      // Aplicar suavizado simple para simular promedio de 3 segundos
      // En una implementación real necesitaríamos el historial de los últimos 3 segundos
      if (averagePower > 0) {
        // Usar una media ponderada: 70% potencia actual, 30% promedio historico
        // Esto simula un suavizado temporal
        return (currentPower * 0.7f + averagePower * 0.3f).format("%.0f");
      } else {
        // Si no hay datos históricos, devolver la potencia actual
        return currentPower.format("%.0f");
      }
    }

    function getAveragePower(info as Activity.Info) as String {
      if (info has :averagePower && info.averagePower != null) {
        return info.averagePower.toFloat().format("%.0f");
      } else {
        return "---";
      }
    }
  }
}
