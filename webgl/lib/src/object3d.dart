import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/interface/IComponent.dart';

abstract class Object3d extends IEditElement {
  //Todo : S'assurer que les noms soient uniques ?!
  String _name = '';
  String get name => _name;
  set name(String value) => _name = value;

  bool _visible = true;
  bool get visible => _visible;
  set visible(bool value) =>
      _visible = value; //Transform : position, rotation, scale

  // >> trsnforms

  final Matrix4 _transform = new Matrix4.identity();
  Matrix4 get transform => _transform;
  set transform(Matrix4 value) => _transform.setFrom(value);

  Vector3 get position => transform.getTranslation();
  set position(Vector3 value) => transform.setTranslation(value);

  Matrix3 get rotation => transform.getRotation();
  set rotation(Matrix3 value) => transform.setRotation(value);

  void translate(Vector3 vector3) {
    this.position += vector3;
  }

  List<IComponent> components = new List();
  void update(){
    components.forEach((c)=> c.update());
  }

  void render();
}