import Toybox.Lang;
import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application.Storage;
import Toybox.Activity;
import Toybox.SensorHistory;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

module AltitudeGetters {
  module Getters {
    // Variables para mantener historial de cálculo de inclinación
    var previousAltitude as Float = 0.0f;
    var previousDistance as Float = 0.0f;
    var currentGrade as Float = 0.0f;
    var isInitialized as Boolean = false;

    // Configuración para el cálculo de inclinación
    const MIN_DISTANCE_FOR_GRADE = 10.0f; // Mínimos 10 metros para calcular inclinación
    const GRADE_SMOOTHING_FACTOR = 0.3f; // Factor de suavizado (0.0 = sin suavizado, 1.0 = sin filtro)

    function getAltitude(info as Activity.Info) as Float {
      if (info has :altitude && info.altitude != null) {
        return info.altitude.toFloat();
      } else {
        return 0.0f; // Default fallback value
      }
    }

    function getTotalAscent(info as Activity.Info) as Float {
      if (info has :totalAscent && info.totalAscent != null) {
        return info.totalAscent.toFloat();
      } else {
        return 0.0f; // Default fallback value
      }
    }

    function getTotalDescent(info as Activity.Info) as Float {
      if (info has :totalDescent && info.totalDescent != null) {
        return info.totalDescent.toFloat();
      } else {
        return 0.0f; // Default fallback value
      }
    }

    /**
     * Calcula el porcentaje de inclinación actual basado en el cambio de altitud
     * y la distancia recorrida
     */
    function getCurrentGradePercentage(info as Activity.Info) as Float {
      var currentAltitude = getAltitude(info);
      var currentDistance = getCurrentDistance(info);

      if (currentDistance <= 50.0f) {
        return 0.0f;
      }

      // Inicialización en la primera llamada
      if (!isInitialized) {
        previousAltitude = currentAltitude;
        previousDistance = currentDistance;
        isInitialized = true;
        return 0.0f;
      }

      var distanceDelta = currentDistance - previousDistance;
      var altitudeDelta = currentAltitude - previousAltitude;

      // Solo calcular si hemos recorrido suficiente distancia
      if (distanceDelta >= MIN_DISTANCE_FOR_GRADE) {
        var instantGrade = (altitudeDelta / distanceDelta) * 100.0f;

        // Aplicar suavizado para evitar cambios bruscos
        currentGrade = currentGrade * (1.0f - GRADE_SMOOTHING_FACTOR) + instantGrade * GRADE_SMOOTHING_FACTOR;

        // Actualizar valores anteriores
        previousAltitude = currentAltitude;
        previousDistance = currentDistance;
      }

      return currentGrade;
    }

    /**
     * Devuelve el porcentaje de inclinación separado en parte entera y decimal
     * Retorna: {:integer => 5, :decimal => 7} para 5.7%
     */
    function getCurrentGradePercentageParts(info as Activity.Info) as Dictionary {
      var gradeFloat = getCurrentGradePercentage(info);
      var isNegative = gradeFloat < 0.0f;
      var absGrade = isNegative ? -gradeFloat : gradeFloat;

      var integerPart = absGrade.toNumber();
      var decimalPart = ((absGrade - integerPart) * 10.0f).toNumber();

      // Aplicar el signo solo a la parte entera si es negativo
      if (isNegative) {
        integerPart = -integerPart;
      }

      return {
        :integer => integerPart,
        :decimal => decimalPart,
        :isNegative => isNegative,
      };
    }

    /**
     * Calcula la inclinación promedio basada en el ascenso/descenso total
     * y la distancia total recorrida
     */
    function getAverageGradePercentage(info as Activity.Info) as Float {
      var totalDistance = getCurrentDistance(info);
      var netElevationChange = getTotalAscent(info) - getTotalDescent(info);

      if (totalDistance > 0.0f) {
        return (netElevationChange / totalDistance) * 100.0f;
      } else {
        return 0.0f;
      }
    }

    /**
     * Obtiene la distancia actual en metros desde Activity.Info
     */
    function getCurrentDistance(info as Activity.Info) as Float {
      if (info has :elapsedDistance && info.elapsedDistance != null) {
        return info.elapsedDistance.toFloat();
      } else {
        return 0.0f;
      }
    }

    /**
     * Calcula la inclinación usando un método más avanzado basado en
     * el historial de posiciones GPS si está disponible
     */
    function getGPSBasedGradePercentage(info as Activity.Info) as Float {
      // Esta función requiere acceso al historial de posiciones GPS
      // Para implementación completa, necesitarías usar Position.getPositionHistory()

      // Por ahora, devolvemos la inclinación actual como fallback
      return getCurrentGradePercentage(info);
    }

    /**
     * Formatea el porcentaje de inclinación para mostrar
     */
    function getFormattedGradePercentage(info as Activity.Info) as String {
      var grade = getCurrentGradePercentage(info);

      // Formatear con un decimal y símbolo de porcentaje
      return grade.format("%.1f") + "%";
    }

    /**
     * Determina si la inclinación es significativa (subida/bajada)
     */
    function getGradeCategory(info as Activity.Info) as String {
      var grade = getCurrentGradePercentage(info);

      if (grade >= 8.0f) {
        return "Muy empinado";
      } else if (grade >= 5.0f) {
        return "Empinado";
      } else if (grade >= 2.0f) {
        return "Subida";
      } else if (grade <= -8.0f) {
        return "Muy empinado ↓";
      } else if (grade <= -5.0f) {
        return "Empinado ↓";
      } else if (grade <= -2.0f) {
        return "Bajada";
      } else {
        return "Plano";
      }
    }

    /**
     * Reinicia los valores de cálculo de inclinación (útil al iniciar nueva actividad)
     */
    function resetGradeCalculation() as Void {
      isInitialized = false;
      currentGrade = 0.0f;
      previousAltitude = 0.0f;
      previousDistance = 0.0f;
    }
  }
}
