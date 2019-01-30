import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/lights/light.dart';
import 'package:webgl/src/lights/light_type.dart';

/// Direction from where the light is coming to origin
class DirectionalLight extends Light{
  LightType get lightType => LightType.directional;

  Vector3 direction;

  DirectionalLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    direction = new Vector3(1.0, 1.0, 1.0);
  }
}