import 'package:gltf/gltf.dart' as glTF;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/program_setting.dart';
import 'package:webgl/src/gtlf/skin.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/camera.dart';

class GLTFNode extends GLTFChildOfRootProperty{
  static int nextId = 0;

  glTF.Node _gltfSource;
  glTF.Node get gltfSource => _gltfSource;

  final int nodeId = nextId++;

  bool get hasChildren => gltfSource.children != null && gltfSource.children.length > 0;

  ProgramSetting programSetting;

  Vector3 _translation = new Vector3.all(0.0);
  Vector3 get translation => _translation;
  set translation(Vector3 value) {
    _translation = value;
    _updateMatrix();
  }

  Quaternion _rotation = new Quaternion.identity();
  Quaternion get rotation => _rotation;
  set rotation(Quaternion value) {
    _rotation = value;
    _updateMatrix();
  }

  Vector3 _scale = new Vector3.all(1.0);
  Vector3 get scale => _scale;
  set scale(Vector3 value) {
    _scale = value;
    _updateMatrix();
  }

  void _updateMatrix(){
    _matrix.setFromTranslationRotationScale(_translation, _rotation, _scale);
  }

  Matrix4 _matrix = new Matrix4.identity();
  Matrix4 get matrix => _matrix;
  set matrix(Matrix4 value) {
    _matrix = value;
    _translation = _matrix.getTranslation();
    _rotation = new Quaternion.fromRotation(_matrix.getRotation());
    _scale = new Vector3(_matrix.getColumn(0).length, _matrix.getColumn(1).length, _matrix.getColumn(2).length);
  }

  Matrix4 get parentMatrix =>  parent != null ?  (parent.parentMatrix * parent.matrix) as Matrix4 : new Matrix4.identity();

  List<double> weights;

  int _meshId;
  GLTFMesh get mesh => _meshId != null ? gltfProject.meshes[_meshId] : null;

  int _cameraId;
  Camera get camera => _cameraId != null ? gltfProject.cameras[_cameraId] : null;

  GLTFSkin skin;

  List<GLTFNode> _children = new List();
  List<GLTFNode> get children => _children;
  set children(List<GLTFNode> value) {
    _children = value;
  }

  GLTFNode _parent;
  GLTFNode get parent => _parent;
  set parent(GLTFNode value) {
    _parent = value;
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
      GLTFMesh mesh = gltfProject.getMesh(gltfSource.mesh);
      node._meshId = mesh.meshId;
    }

    if(gltfSource.camera != null){
      Camera camera = gltfProject.getCamera(gltfSource.camera);
      node._cameraId = camera.cameraId;
    }

    return node;
  }

  @override
  String toString() {
    return 'GLTFNode{nodeId: $nodeId, matrix: $matrix, translation: $translation, rotation: $rotation, scale: $scale, weights: $weights, camera: $camera, children: ${children.map((n)=>n.nodeId).toList()}, mesh: $_meshId, parent: ${parent.nodeId}, skin: $skin, isJoint: $isJoint}';
  }

  //>


}
