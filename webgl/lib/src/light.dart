import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/object3d.dart';
import 'package:webgl/src/models.dart';
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

class Light extends Object3d{
  Vector3 color;
  Light();

  @override
  void render() {
    // TODO: implement render
  }

  // >> JSON

  factory Light.fromJson(Map json) {
    return null;
  }

  Map toJson() {
    Map json = new Map();
    return json;
  }
}

class AmbientLight extends Light{
  AmbientLight() {
    color = new Vector3(1.0, 1.0, 1.0);
  }
}

class PointLight extends Light{
  Vector3 position;

  PointLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    position = new Vector3(0.0, 0.0, 0.0);
  }
}

class DirectionalLight extends Light{
  Vector3 direction;

  DirectionalLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    direction = new Vector3(1.0, 1.0, 1.0);
  }
}