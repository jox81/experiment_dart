import 'package:gltf/gltf.dart' as glTF;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
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

  Matrix4 get parentMatrix =>  parent != null ?  (parent.parentMatrix * parent.matrix) as Matrix4 : new Matrix4.identity();

  Vector3 translation = new Vector3.all(0.0);
  Quaternion rotation = new Quaternion.identity();
  Vector3 scale = new Vector3.all(1.0);

  List<double> weights;

  int _meshId;
  GLTFMesh get mesh => _meshId != null ? gltfProject.meshes[_meshId] : null;

  int _cameraId;
  Camera get camera => _cameraId != null ? gltfProject.cameras[_cameraId] : null;

  GLTFSkin skin;

  List<GLTFNode> get children => gltfProject.nodes.where((n)=>n.parent == this).toList(growable: false);

  int _parentId;
  GLTFNode get parent => _parentId != null ? gltfProject.nodes[_parentId] : null;
  set parent(GLTFNode value) {
    _parentId = gltfProject.nodes.indexOf(value);
  }

  bool isJoint = false;

  GLTFNode._(this._gltfSource):
  super(_gltfSource.name) {
      if(gltfSource.translation != null) translation = gltfSource.translation;
      if(gltfSource.rotation != null) rotation = gltfSource.rotation;
      if(gltfSource.scale != null) scale = gltfSource.scale;
      if(gltfSource.matrix != null) matrix = gltfSource.matrix;
  }

  static int getParentId(glTF.Node _gltfSource){

    int parentId;

    //Cherche si il existe un node
    glTF.Node node = (gltfProject.gltfSource.nodes.firstWhere((n)=>n == _gltfSource, orElse: ()=>null));
    if(node != null) {
      parentId = gltfProject.gltfSource.nodes.indexOf(node.parent);
      parentId = parentId != -1 ? parentId : null;
    }
    return parentId;
  }

  GLTFNode({GLTFMesh mesh,String name}):super(name){
    if(mesh != null) {
      this._meshId = gltfProject.meshes.indexOf(mesh);
    }
  }

  factory GLTFNode.fromGltf(glTF.Node gltfSource) {
    if (gltfSource == null) return null;

    GLTFNode node = new GLTFNode._(gltfSource);

    if(gltfSource.mesh != null){
      GLTFMesh mesh = gltfProject.meshes.firstWhere((m)=>m.gltfSource == gltfSource.mesh, orElse: ()=> throw new Exception('Node mesh can only be bound to an existing project mesh'));
      node._meshId = mesh.meshId;
    }

    if(gltfSource.camera != null){
      Camera camera = gltfProject.cameras.firstWhere((c)=>c.gltfSource == gltfSource.camera, orElse: ()=> throw new Exception('Node camera can only be bound to an existing project camera'));
      node._cameraId = camera.cameraId;
    }

    return node;
  }

  @override
  String toString() {
    return 'GLTFNode{nodeId: $nodeId, matrix: $matrix, translation: $translation, rotation: $rotation, scale: $scale, weights: $weights, camera: $camera, children: ${children.map((n)=>n.nodeId).toList()}, mesh: $_meshId, parent: $_parentId, skin: $skin, isJoint: $isJoint}';
  }

  //>

  ProgramSetting programSetting;
}
