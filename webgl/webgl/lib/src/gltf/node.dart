import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/gltf/skin.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/interface/IComponent.dart';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
class GLTFNode extends GLTFChildOfRootProperty{
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

  GLTFNode({
    String name : ''
  }): super(name){
    GLTFEngine.currentProject?.addNode(this);
  }

  Matrix4 get parentMatrix =>  parent != null ?  (parent.parentMatrix * parent.matrix) as Matrix4 : new Matrix4.identity();

  Set<GLTFNode> _children = new Set();
  List<GLTFNode> get children => _children.toList(growable: false);
  set children(List<GLTFNode> children) {
    print('GLTFNode.children');
    print(children.length);
    for (GLTFNode node in children) {
      node._parent = this;
    }
    _children.clear();
    _children.addAll(children);
  }

  void addChild(GLTFNode node){
    print('GLTFNode.addChild');
    if(node == null) return;
    _children.add(node);
    node._parent = this;
  }

  GLTFNode _parent;
  GLTFNode get parent => _parent;
  set parent(GLTFNode node) {
    print('GLTFNode.parent');
    if(node != null)node._children.add(this);
    _parent = node;
  }

  List<double> weights;
  GLTFSkin skin;
  bool isJoint = false;

  GLTFMesh _mesh;
  GLTFMesh get mesh => _mesh;
  set mesh(GLTFMesh value) {
    _mesh = value;
  }

  Camera _camera;
  Camera get camera => _camera;
  set camera(Camera value) {
    _camera = value;
  }

  bool _visible = true;
  bool get visible => _visible;
  set visible(bool value) =>
      _visible = value;

  List<IComponent> _components = new List();
  void addComponent(IComponent component) {
    _components.add(component
      ..node = this);
  }
  void update(){
    _components.forEach((c)=> c.update());
  }

  @override
  String toString() {
    return 'GLTFNode{nodeId: $nodeId, matrix: $matrix, translation: $translation, rotation: $rotation, scale: $scale, weights: $weights, camera: $camera, children: ${children.map((n)=>n.nodeId).toList()}, mesh: ${_mesh?.meshId}, parent: ${parent?.nodeId}, skin: $skin, isJoint: $isJoint}';
  }
}
