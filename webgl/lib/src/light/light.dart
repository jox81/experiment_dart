import 'package:vector_math/vector_math.dart';
@MirrorsUsed(
    targets: const [
      Light,
      AmbientLight,
      PointLight,
      DirectionalLight,
      DirectionalLight,
    ],
    override: '*')
import 'dart:mirrors';

import 'package:webgl/src/gltf/node.dart';

enum LightType {
  ambient,
  point,
  directional,
}

abstract class Light extends GLTFNode {

  LightType lightType;

  Vector3 color;
  Light();

  // >> JSON

  factory Light.fromJson(Map json) {
    return null;
  }

  Map toJson() {
    Map json = new Map<String, Object>();
    return json;
  }
}

class AmbientLight extends Light{
  LightType get lightType => LightType.ambient;

  AmbientLight() {
    color = new Vector3(1.0, 1.0, 1.0);
  }
}

class PointLight extends Light{
  LightType get lightType => LightType.point;

  Vector3 translation;

  PointLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    translation = new Vector3(100.0, 100.0, 100.0);
  }
}

class DirectionalLight extends Light{
  LightType get lightType => LightType.directional;

  Vector3 direction;

  DirectionalLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    direction = new Vector3(1.0, 1.0, 1.0);
  }
}