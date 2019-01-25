import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/lights/light_type.dart';

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