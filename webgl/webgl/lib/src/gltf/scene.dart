import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/mesh/mesh_type.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
class GLTFScene extends GLTFChildOfRootProperty{
  static int nextId = 0;
  final int sceneId = nextId++;

  Vector4 backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  List<GLTFNode> _nodes = <GLTFNode>[];
  List<GLTFNode> get nodes => _nodes;
  void addNode(GLTFNode node){
    assert(node != null);
    _nodes.add(node);
  }

  GLTFScene({String name:''}):super(name){
    GLTFEngine.activeProject.addScene(this);
  }

  void makeCurrent() {
    GLTFEngine.activeProject.scene = this;
  }

  void createMeshByType(MeshType meshType){
    GLTFMesh mesh = new GLTFMesh.byMeshType(meshType);

    GLTFNode nodeQuad = new GLTFNode()
      ..mesh = mesh
      ..matrix.translate(0.0, 0.0, 0.0);
    addNode(nodeQuad);
  }

  @override
  String toString() {
    return 'GLTFScene{nodes: ${_nodes.map((n)=>n.nodeId).toList()}}';
  }
}