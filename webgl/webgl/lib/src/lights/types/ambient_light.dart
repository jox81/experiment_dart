import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/lights/light.dart';
import 'package:webgl/src/lights/light_type.dart';

class AmbientLight extends Light{
  @override
  LightType get lightType => LightType.ambient;

  AmbientLight() {
    color = new Vector3(1.0, 1.0, 1.0);
  }
}