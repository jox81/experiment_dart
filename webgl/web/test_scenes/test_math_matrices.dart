import 'dart:math';
import 'package:vector_math/vector_math.dart';

void main() {
  num angle = radians(90.0);

  num c = cos(angle);
  num s = sin(angle);

  Vector3 v = new Vector3(1.0,0.0,0.0);

  Matrix4 S = new Matrix4.identity()..scale(1.0);
  Matrix4 R = new Matrix4.identity()..setRotationZ(angle);
  Matrix4 T = new Matrix4.identity()..setTranslation(new Vector3(1.0,0.0,0.0));

//  Vector3 vr1 = S * v;
//  Vector3 vr2 = R * v;
//  Vector3 vr3 = T * v;

  //
  Vector3 vR1 = T * R * S * v;

  //
  Vector3 vr4 = S * v;
  Vector3 vr5 = R * vr4;
  Vector3 vR2 = T * vr5;
  bool same2 = vR1 == vR2;

  //
  Matrix4 mr4 = T * R;
  Matrix4 mr5 = mr4 * S;
  Vector3 vR3 = mr5 * v;
  bool same3 = vR1 == vR3;

  //
  Vector3 vr7 = S * v;
  Vector3 vr8 = R * vr7;
  Vector3 vR4 = T * vr8;
  bool same4 = vR1 == vR4;

  //
//  Matr vR5 = T
//    ..multiply(R)
//    ..multiply(S);
//  * v;
//  bool same5 = vR1 == vR5;

  print('');
}
