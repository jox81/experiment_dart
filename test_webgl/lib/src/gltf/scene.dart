import 'package:vector_math/vector_math.dart';
import 'package:test_webgl/src/gltf/node.dart';
import 'package:test_webgl/src/gltf/project.dart';
import 'package:test_webgl/src/gltf/utils_gltf.dart';

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
    GLTFProject.instance.addScene(this);
  }

  @override
  String toString() {
    return 'GLTFScene{nodes: ${_nodes.map((n)=>n.nodeId).toList()}}';
  }

  void makeCurrent() {
    GLTFProject.instance.scene = this;
  }
}
