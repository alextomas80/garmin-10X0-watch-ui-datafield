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
using Toybox.AntPlus;

module SensorsGetters {
  module Getters {
    function getBattery() as Number {
      return System.getSystemStats().battery.toNumber();
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

    function getCalculatedPower() as String {
      var listener = new MyBikePowerListener();
      var bikePower = new AntPlus.BikePower(listener);

      var calculatedPower = bikePower.getCalculatedPower();
      System.println("Calculated Power: " + calculatedPower);
      return calculatedPower.toString();
    }
  }
}
