import 'dart:math' as Math;

class UtilsMath {
  static double roundPrecision(double value, {int precision : 2}){
    num roundPrecision = Math.pow(10, precision);
    return (value * roundPrecision).floorToDouble() / roundPrecision;
  }

  ///if startValue == 6 && multiple == 4 > result = 8;
  static int findNextIntMultiple(int startValue, int multiple){
    startValue -= 1;
    return  startValue + (multiple - startValue % multiple);
  }
}