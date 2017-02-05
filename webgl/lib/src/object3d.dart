import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection.dart';

abstract class Object3d extends IEditElement {
  //Todo : S'assurer que les noms soient uniques ?!
  String _name = '';
  String get name => _name;
  set name(String value) => _name = value;

  final Matrix4 _transform = new Matrix4.identity();
  Matrix4 get transform => _transform;
  set transform(Matrix4 value) => _transform.setFrom(value);

  Vector3 get position => transform.getTranslation();
  set position(Vector3 value) => transform.setTranslation(value);

  Matrix3 get rotation => transform.getRotation();
  set rotation(Matrix3 value) => transform.setRotation(value);

  void render();
}