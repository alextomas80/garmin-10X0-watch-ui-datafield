import Toybox.Activity;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.WatchUi.DataField;

module Utils {
  class NumberFormatter {
    // Formatear un float con el número de decimales especificado
    (:inline)
    static function formatFloat(value as Float, decimals as Number) as String {
      if (decimals < 0 || decimals > 6) {
        // Limitar decimales a un rango razonable
        decimals = 2;
      }

      // Manejar valores negativos
      var isNegative = value < 0;
      if (isNegative) {
        value = -value;
      }

      // Calcular la potencia de 10 para los decimales
      var multiplier = 1;
      for (var i = 0; i < decimals; i++) {
        multiplier *= 10;
      }

      // Obtener parte entera y decimal
      var intPart = value.toNumber();
      var decimalPart = ((value - intPart) * multiplier).toNumber();

      // Asegurar que la parte decimal esté en el rango correcto
      decimalPart = decimalPart % multiplier;

      // Construir el string de decimales con ceros a la izquierda
      var decimalStr = "";
      if (decimals > 0) {
        decimalStr = formatDecimalPart(decimalPart, decimals);
      }

      // Construir resultado final
      var result = (isNegative ? "-" : "") + intPart.toString();
      if (decimals > 0) {
        result += "." + decimalStr;
      }

      return result;
    }

    // Formatear parte decimal con ceros a la izquierda
    (:inline)
    private static function formatDecimalPart(value as Number, decimals as Number) as String {
      var str = value.toString();

      // Agregar ceros a la izquierda si es necesario
      while (str.length() < decimals) {
        str = "0" + str;
      }

      // Truncar si es más largo (protección)
      if (str.length() > decimals) {
        str = str.substring(0, decimals);
      }

      return str;
    }

    // Formatear con 1 decimal
    (:inline)
    static function formatFloat1(value as Float) as String {
      return formatFloat(value, 1);
    }

    // Formatear con 2 decimales
    (:inline)
    static function formatFloat2(value as Float) as String {
      return formatFloat(value, 2);
    }

    // Formatear con 3 decimales
    (:inline)
    static function formatFloat3(value as Float) as String {
      return formatFloat(value, 3);
    }

    // Formatear entero con separadores de miles usando substring
    static function formatInteger(value as Number, useSeparator as Boolean) as String {
      var str = value.toString();

      if (!useSeparator || str.length() <= 3) {
        return str;
      }

      var result = "";
      var length = str.length();

      // Procesar desde el final hacia adelante usando substring
      for (var i = 0; i < length; i++) {
        var pos = length - 1 - i;
        if (i > 0 && i % 3 == 0) {
          result = "," + result;
        }
        result = str.substring(pos, pos + 1) + result;
      }

      return result;
    }

    // Redondear un float a decimales específicos
    (:inline)
    static function roundFloat(value as Float, decimals as Number) as Float {
      var multiplier = 1;
      for (var i = 0; i < decimals; i++) {
        multiplier *= 10;
      }

      return (value * multiplier + 0.5).toNumber().toFloat() / multiplier;
    }

    // Formatear porcentaje
    (:inline)
    static function formatPercentage(value as Float, decimals as Number) as String {
      return formatFloat(value, decimals) + "%";
    }

    // Formatear con unidades específicas
    (:inline)
    static function formatWithUnit(value as Float, decimals as Number, unit as String) as String {
      return formatFloat(value, decimals) + unit;
    }
  }

  class StringUtils {
    // Dividir string por delimitador
    static function split(str as String, delimiter as String) as Array {
      var result = [];
      var currentStr = str;
      var delimiterIndex = currentStr.find(delimiter);

      while (delimiterIndex != null) {
        var part = currentStr.substring(0, delimiterIndex);
        result.add(part);
        currentStr = currentStr.substring(delimiterIndex + delimiter.length(), currentStr.length());
        delimiterIndex = currentStr.find(delimiter);
      }

      if (currentStr.length() > 0) {
        result.add(currentStr);
      }

      return result;
    }

    // Limpiar espacios en blanco al inicio y final
    static function trim(str as String) as String {
      var start = 0;
      var end = str.length();

      // Encontrar primer carácter no espacio
      while (start < end && str.substring(start, start + 1).equals(" ")) {
        start++;
      }

      // Encontrar último carácter no espacio
      while (end > start && str.substring(end - 1, end).equals(" ")) {
        end--;
      }

      return str.substring(start, end);
    }

    // Verificar si string está vacío o null
    (:inline)
    static function isEmpty(str as String?) as Boolean {
      return str == null || str.length() == 0;
    }

    // Pad con ceros a la izquierda
    static function padLeft(str as String, length as Number, padChar as String) as String {
      while (str.length() < length) {
        str = padChar + str;
      }
      return str;
    }
  }

  class ValidationUtils {
    // Validar rango de número
    (:inline)
    static function isInRange(value as Number, min as Number, max as Number) as Boolean {
      return value >= min && value <= max;
    }

    // Validar si es un número válido (no NaN, no infinito)
    (:inline)
    static function isValidNumber(value as Float) as Boolean {
      return value.toString().find("nan") == null && value.toString().find("inf") == null;
    }

    // Clamp value entre min y max
    (:inline)
    static function clamp(value as Number, min as Number, max as Number) as Number {
      if (value < min) {
        return min;
      }
      if (value > max) {
        return max;
      }
      return value;
    }

    (:inline)
    static function isDarkMode(view as WatchUi.DataField) as Boolean {
      return view.getBackgroundColor() == Graphics.COLOR_BLACK;
    }

    (:inline) // if (screenWidth == 246 && screenHeight == 322) {
    static function is8X0(dc as Dc) as Boolean {
      return dc.getWidth() == 246 && dc.getHeight() == 322;
    }
  }
}
