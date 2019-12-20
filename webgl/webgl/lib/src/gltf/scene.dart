import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/mesh/mesh_type.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/introspection/introspection.dart';

//@reflector
class GLTFScene extends GLTFChildOfRootProperty{
  static int nextId = 0;
  final int sceneId = nextId++;

  Vector4 backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  Set<GLTFNode> _nodes = new Set<GLTFNode>();
  List<GLTFNode> get nodes => _nodes.toList(growable: false);
  void addNode(GLTFNode node){
    assert(node != null);
    _nodes.add(node);
    for (GLTFNode childNode in node.children) {
      addNode(childNode);
    }
  }

  void removeNode(GLTFNode node){
    assert(node != null);
    for (GLTFNode childNode in node.children) {
      removeNode(childNode);
    }
    _nodes.remove(node);
  }

  GLTFScene({String name:''}):super(name){
    GLTFEngine.currentProject.addScene(this);
  }

  void makeCurrent() {
    GLTFEngine.currentProject.scene = this;
  }

  void createMeshByType(MeshType meshType){
    GLTFNode nodeQuad = new GLTFNode()
      ..mesh = new GLTFMesh.byMeshType(meshType)
      ..matrix.translate(0.0, 0.0, 0.0);
    addNode(nodeQuad);
  }

  @override
  String toString() {
    return 'GLTFScene{nodes: ${_nodes.map((n)=>n.nodeId).toList()}}';
  }
}