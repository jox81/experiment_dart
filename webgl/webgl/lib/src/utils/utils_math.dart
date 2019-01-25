import 'dart:math' as Math;
import 'dart:typed_data';

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

  static Float32List convertVec2FloatListToVec3FloatList(Float32List baseList, double fillValue) {
    List<int> data = baseList.buffer.asUint8List().toList();

    int vec2ComponentsCount = 2;
    int vec2LengthInByte = 2 * 4;
    int vec3LengthInByte = 3 * 4;
    int count = baseList.length ~/ vec2ComponentsCount;

    for(int i = vec2LengthInByte; i < count*vec3LengthInByte; i+=vec3LengthInByte) {
      data.insertAll(i, new Float32List.fromList([fillValue]).buffer.asUint8List());
    }

    baseList = new Uint8List.fromList(data).buffer.asFloat32List();
    return baseList;
  }
}