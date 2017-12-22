import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFScene extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int sceneId = nextId++;

  List<GLTFNode> _nodes = <GLTFNode>[];
  List<GLTFNode> get nodes => _nodes;
  void addNode(GLTFNode node){
    assert(node != null);
    _nodes.add(node);
  }

  GLTFScene({String name:''}):super(name);

  @override
  String toString() {
    return 'GLTFScene{nodes: ${_nodes.map((n)=>n.nodeId).toList()}}';
  }
}
