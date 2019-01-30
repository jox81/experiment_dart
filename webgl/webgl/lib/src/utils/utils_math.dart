import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

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

  static Vector3 vector3Lerp(Vector3 v0, Vector3 v1, double t) {
    return v0 + (v1 - v0).scaled(t);
  }

  static Quaternion slerp(Quaternion qa, Quaternion qb, double t) {
    bool useSimple = true;

    // quaternion to return
    Quaternion qm;

    if (useSimple) {
      qm = qa + (qb - qa).scaled(t);
    } else {
      qm = new Quaternion.identity();

      // Calculate angle between them.
      double cosHalfTheta =
          qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

      // if qa=qb or qa=-qb then theta = 0 and we can return qa
      if (cosHalfTheta.abs() >= 1.0) {
        qm.w = qa.w;
        qm.x = qa.x;
        qm.y = qa.y;
        qm.z = qa.z;
        return qm;
      }

      // Calculate temporary values.
      double halfTheta = Math.acos(cosHalfTheta);
      double sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

      // if theta = 180 degrees then result is not fully defined
      // we could rotate around any axis normal to qa or qb
      if (sinHalfTheta.abs() < 0.001) {
        qm.w = (qa.w * 0.5 + qb.w * 0.5);
        qm.x = (qa.x * 0.5 + qb.x * 0.5);
        qm.y = (qa.y * 0.5 + qb.y * 0.5);
        qm.z = (qa.z * 0.5 + qb.z * 0.5);
        return qm;
      }
      double ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta;
      double ratioB = Math.sin(t * halfTheta) / sinHalfTheta;

      //calculate Quaternion.
      qm.w = (qa.w * ratioA + qb.w * ratioB);
      qm.x = (qa.x * ratioA + qb.x * ratioB);
      qm.y = (qa.y * ratioA + qb.y * ratioB);
      qm.z = (qa.z * ratioA + qb.z * ratioB);
    }
    return qm;
  }

  static Float32List getInterpolatedValues(Float32List previousValues,
      Float32List nextValues, num interpolationValue) {
    Float32List result = new Float32List(previousValues.length);

    for (int i = 0; i < previousValues.length; i++) {
      result[i] = previousValues[i] +
          interpolationValue * (nextValues[i] - previousValues[i]);
    }
    return result;
  }
}