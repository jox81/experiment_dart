import 'package:vector_math/vector_math.dart';

class Light{
  Light();
}

class AmbientLight extends Light{
  Vector3 color;

  AmbientLight() {
    color = new Vector3(1.0, 1.0, 1.0);
  }
}

class DirectionalLight extends Light{
  Vector3 color;
  Vector3 direction;

  DirectionalLight() {
    color = new Vector3(1.0, 1.0, 1.0);
    direction = new Vector3(1.0, 1.0, 1.0);
  }
}