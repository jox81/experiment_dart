import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/lights/light.dart';
import 'package:webgl/src/lights/light_type.dart';

class PointLight extends Light{
  LightType get lightType => LightType.point;

  Vector3 translation;

  PointLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    translation = new Vector3(100.0, 100.0, 100.0);
  }
}