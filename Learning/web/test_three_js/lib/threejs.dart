// Or use import 'package:threejs_facade/three.dart';
// pubspec.yaml :
// threejs_facade:
// git: https://github.com/blockforest/threejs-dart-facade.git

@JS('THREE')
library threejs;

import 'dart:html';
import "package:js/js.dart";

@JS()
abstract class Object3D {
  external Object3D add(Object3D object);
  external Vector3 get position;
  external set position(Vector3 v);

  external Euler get rotation;
  external set rotation(Euler v);

  external Object3D getObjectByName(String name);
}

@JS()
class Scene extends Object3D {
  external factory Scene();
}

@JS()
abstract class Camera extends Object3D {
}

@JS()
class PerspectiveCamera extends Camera {
  external factory PerspectiveCamera(num fov, num aspect, num near, num far);
}

@JS()
class WebGLRenderer {
  external WebGLRenderer();

  external Element get domElement;
  external set domElement(Element v);

  external void setSize(num width, num height, [bool updateStyle]);
  external void render(Scene scene, Camera camera, [WebGLRenderTarget renderTarget, bool forceClear ]);
}

@JS()
abstract class Geometry {
}

@JS()
class BoxGeometry extends Geometry {
  external BoxGeometry(width, height, depth,
      [widthSegments, heightSegments, depthSegments]);
}

@JS()
abstract class Material {
  external Material();
}

@JS()
class MeshBasicMaterial extends Material {
  external MeshBasicMaterial(Map parameters);
}

@JS()
class Mesh extends Object3D {
  external Mesh(Geometry geometry, Material material);
}

@JS()
class Vector3 {
  external Vector3();

  external num get x;
  external set x(num v);
  external num get y;
  external set y(num v);
  external num get z;
  external set z(num v);
}

@JS()
class Euler {
  external Euler();

  external num get x;
  external set x(num v);

  external num get y;
  external set y(num v);

  external num get z;
  external set z(num v);
}

@JS()
class WebGLRenderTarget {
  external WebGLRenderTarget();
}

//@anonymous
//@JS()
//class base {}
