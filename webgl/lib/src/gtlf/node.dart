import 'package:gltf/gltf.dart' as glTF;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/skin.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/camera.dart';

class GLTFNode extends GLTFChildOfRootProperty{
  glTF.Node _gltfSource;
  glTF.Node get gltfSource => _gltfSource;
  int nodeId;

  Matrix4 _matrix = new Matrix4.identity();
  Matrix4 get matrix => _matrix..setFromTranslationRotationScale(translation, rotation, scale);
  set matrix(Matrix4 value) {
    _matrix = value;
    translation = _matrix.getTranslation();
    rotation = new Quaternion.fromRotation(_matrix.getRotation());
    scale = new Vector3(_matrix.getColumn(0).length, _matrix.getColumn(1).length, _matrix.getColumn(2).length);
  }

  Vector3 translation = new Vector3.all(0.0);
  Quaternion rotation = new Quaternion.identity();
  Vector3 scale = new Vector3.all(1.0);

  List<double> weights;

  Camera camera;
  GLTFMesh mesh;
  GLTFSkin skin;
  List<GLTFNode> get children => gltfProject.nodes.toList().where((n)=>n.parent == this).toList(growable: false);

  int _parentId;
  set parent(GLTFNode value) {
    _parentId = gltfProject.nodes.indexOf(value);
  }
  GLTFNode get parent => _parentId != null ? gltfProject.nodes[_parentId] : null;

  bool isJoint = false;

  GLTFNode._(this._gltfSource) :
        this.camera = Camera.fromGltf(_gltfSource.camera),
        this._parentId = _getParentId(_gltfSource),
        this.mesh = new GLTFMesh.fromGltf(_gltfSource.mesh);

  static int _getParentId(glTF.Node _gltfSource){

    int parentId;

    //Cherche si il existe un node
    glTF.Node node = (gltfProject.gltfSource.nodes.firstWhere((n)=>n == _gltfSource, orElse: ()=>null));
    if(node != null) {
      parentId = gltfProject.gltfSource.nodes.indexOf(node.parent);
      parentId = parentId != -1 ? parentId : null;
    }
    return parentId;
  }

  GLTFNode();

  factory GLTFNode.fromGltf(glTF.Node gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFNode._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFNode{nodeId: $nodeId, matrix: $matrix, translation: $translation, rotation: $rotation, scale: $scale, weights: $weights, camera: $camera, children: ${children.map((n)=>n.nodeId).toList()}, mesh: $mesh, parent: $_parentId, skin: $skin, isJoint: $isJoint}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFNode &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              _matrix == other._matrix &&
              translation == other.translation &&
              rotation.toString() == other.rotation.toString() &&
              scale == other.scale &&
              weights == other.weights &&
              camera == other.camera &&
              mesh == other.mesh &&
              skin == other.skin &&
              _parentId == other._parentId &&
              isJoint == other.isJoint;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      nodeId.hashCode ^
      _matrix.hashCode ^
      translation.hashCode ^
      rotation.hashCode ^
      scale.hashCode ^
      weights.hashCode ^
      camera.hashCode ^
      mesh.hashCode ^
      skin.hashCode ^
      _parentId.hashCode ^
      isJoint.hashCode;



}
