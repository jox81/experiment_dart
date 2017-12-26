import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/interface/IComponent.dart';

class Node extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int nodeId = nextId++;

  Vector3 _translation = new Vector3.all(0.0);
  Vector3 get translation => _translation;
  set translation(Vector3 value) {
    if(value == null)return;
    _translation = value;
    _updateMatrix();
  }

  Quaternion _rotation = new Quaternion.identity();
  Quaternion get rotation => _rotation;
  set rotation(Quaternion value) {
    if(value == null) return;
    _rotation = value;
    _updateMatrix();
  }

  Vector3 _scale = new Vector3.all(1.0);
  Vector3 get scale => _scale;
  set scale(Vector3 value) {
    if(value == null) return;
    _scale = value;
    _updateMatrix();
  }

  Matrix4 _matrix = new Matrix4.identity();
  Matrix4 get matrix => _matrix;
  set matrix(Matrix4 value) {
    if(value == null) return;
    _matrix = value;
    _translation = _matrix.getTranslation();
    _rotation = new Quaternion.fromRotation(_matrix.getRotation());
    _scale = new Vector3(_matrix.getColumn(0).length, _matrix.getColumn(1).length, _matrix.getColumn(2).length);
  }

  void _updateMatrix(){
    _matrix.setFromTranslationRotationScale(_translation, _rotation, _scale);
  }

  void translate(Vector3 vector3) {
    this.translation += vector3;
  }

  Node({
    String name : ''
  }): super(name);

  bool _visible = true;
  bool get visible => _visible;
  set visible(bool value) =>
      _visible = value; //Transform : position, rotation, scale

  List<IComponent> components = new List();

  void addComponent(IComponent component) {
    components.add(component
    ..node = this);
  }

  void update(){
    components.forEach((c)=> c.update());
  }

  void render(){}
}