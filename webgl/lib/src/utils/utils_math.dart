import 'dart:math' as Math;

class UtilsMath {
  static double roundPrecision(double value, {int precision : 2}){
    num roundPrecision = Math.pow(10, precision);
    return (value * roundPrecision).floorToDouble() / roundPrecision;
  }
}