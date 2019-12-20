import 'dart:async';
import 'dart:html';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/nodes/quad.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/gltf/skin.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/interface/IComponent.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/materials/types/base_texture_material.dart';
import 'package:webgl/src/textures/text_style.dart';
import 'package:webgl/src/textures/text_texture.dart';

export 'package:webgl/src/gltf/nodes/line.dart';
export 'package:webgl/src/gltf/nodes/cube.dart';
export 'package:webgl/src/gltf/nodes/sphere.dart';
export 'package:webgl/src/gltf/nodes/quad.dart';
export 'package:webgl/src/gltf/nodes/triangle.dart';
export 'package:webgl/src/gltf/nodes/pyramid.dart';
export 'package:webgl/src/gltf/nodes/vector.dart';
export 'package:webgl/src/gltf/nodes/point.dart';
export 'package:webgl/src/gltf/nodes/grid.dart';

//@reflector
class GLTFNode extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int nodeId = nextId++;

  StreamController<MouseEvent> onClickController = new StreamController<MouseEvent>.broadcast();
  Stream<MouseEvent> get onClick => onClickController.stream;

  bool _enable = true;
  bool get enable => _enable;
  set enable(bool value) {
    _enable = value;
  }

  Vector3 _translation = new Vector3.all(0.0);
  Vector3 get translation => _translation;
  set translation(Vector3 value) {
    if (value == null) return;
    _translation = value;
    _updateMatrix();
  }

  Quaternion _rotation = new Quaternion.identity();
  Quaternion get rotation => _rotation;
  set rotation(Quaternion value) {
    if (value == null) return;
    _rotation = value;
    _updateMatrix();
  }

  Vector3 _scale = new Vector3.all(1.0);
  Vector3 get scale => _scale;
  set scale(Vector3 value) {
    if (value == null) return;
    _scale = value;
    _updateMatrix();
  }

  Matrix4 _matrix = new Matrix4.identity();
  Matrix4 get matrix => _matrix;
  set matrix(Matrix4 value) {
    if (value == null) return;
    _matrix = value;
    _translation = _matrix.getTranslation();
    _rotation = new Quaternion.fromRotation(_matrix.getRotation());
    _scale = new Vector3(_matrix.getColumn(0).length,
        _matrix.getColumn(1).length, _matrix.getColumn(2).length);
  }

  void _updateMatrix() {
    _matrix.setFromTranslationRotationScale(_translation, _rotation, _scale);
  }

  void translate(Vector3 vector3) {
    this.translation += vector3;
  }

// Todo (jpu) : this doesn't work
//  void rotate(Quaternion quaternion) {
//    this.rotation.add(quaternion);
//  }

  GLTFNode({String name: '', GLTFMesh mesh}) : super(name) {
    this.mesh = mesh;
    GLTFEngine.currentProject?.addNode(this);
  }

  GLTFNode._withMesh(GLTFMesh newMesh, {String name: ''}) : this(name:name, mesh:newMesh);

  factory GLTFNode.axis({String name: ''}){
    GLTFNode result = new GLTFNode._withMesh(new GLTFMesh.axis())
    ..material = new MaterialBaseVertexColor();
    return result;
  }

  factory GLTFNode.label(String text, int width, int height, TextStyle textStyle, {String name: ''}){
    //> create label texture
    TextTexture labelTexture = new TextTexture(width, height)
      ..text = text
      ..textStyle = textStyle
      ..draw();

    MaterialBaseTexture rectangleTextureMaterial = new MaterialBaseTexture()
      ..texture = labelTexture;

    QuadGLTFNode nodeQuad = new QuadGLTFNode()
      ..material = rectangleTextureMaterial
//      ..rotation = new Quaternion.axisAngle(new Vector3(0.0, 0.0, 1.0), radians(180))
      ..scale = new Vector3(labelTexture.width * 0.01 , labelTexture.height * 0.01,1.0);
    return nodeQuad;
  }

  Matrix4 get parentMatrix => parent != null
      ? (parent.parentMatrix * parent.matrix) as Matrix4
      : new Matrix4.identity();

  Set<GLTFNode> _children = new Set();
  List<GLTFNode> get children => _children.toList(growable: false);
  set children(List<GLTFNode> children) {
    for (GLTFNode node in children) {
      node._parent = this;
    }
    _children.clear();
    _children.addAll(children);
  }

  void addChild(GLTFNode node) {
    if (node == null) return;
    _children.add(node);
    node._parent = this;
  }

  GLTFNode _parent;
  GLTFNode get parent => _parent;
  set parent(GLTFNode node) {
    if (node != null) node._children.add(this);
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

  GLTFCamera _camera;
  GLTFCamera get camera => _camera;
  set camera(GLTFCamera value) {
    _camera = value;
  }

  bool _visible = true;
  bool get visible => _visible;
  set visible(bool value) => _visible = value;

  ///Use this to define a custom material if needed
  Material _material;
  Material get material => _material;
  set material(Material value) {
    _material = value;
    mesh.primitives[0].material = value;
  }

  List<IComponent> _components = new List();
  void addComponent(IComponent component) {
    _components.add(component..node = this);
  }

  void update() {
    _components.forEach((c) => c.update());
  }

  @override
  String toString() {
    return 'GLTFNode{nodeId: $nodeId, matrix: $matrix, translation: $translation, rotation: $rotation, scale: $scale, weights: $weights, camera: $camera, children: ${children.map((n) => n.nodeId).toList()}, mesh: ${_mesh?.meshId}, parent: ${parent?.nodeId}, skin: $skin, isJoint: $isJoint}';
  }
}
