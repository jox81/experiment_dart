import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFScene extends GLTFChildOfRootProperty {
  static int nextId = 0;

  glTF.Scene _gltfSource;
  glTF.Scene get gltfSource => _gltfSource;

  final int sceneId = nextId++;

  final List<int> _nodesId = new List();
  List<GLTFNode> get nodes => gltfProject.nodes.where((n)=>_nodesId.contains(n.nodeId)).toList(growable: false);
  void addNode(GLTFNode node){
    assert(node != null);
    _nodesId.add(node.nodeId);
  }

  GLTFScene._(this._gltfSource):super(_gltfSource.name);

  GLTFScene([String name]):super(name);

  factory GLTFScene.fromGltf(glTF.Scene gltfSource) {
    if (gltfSource == null) return null;
    GLTFScene scene = new GLTFScene._(gltfSource);

    //Scenes must be handled after nodes
    for(glTF.Node node in gltfSource.nodes){

      GLTFNode gltfNode = gltfProject.nodes.firstWhere((n)=>n.gltfSource == node, orElse: ()=> throw new Exception('Scene can only be binded to Nodes existing in project'));
      scene.addNode(gltfNode);
    }
    return scene;
  }

  @override
  String toString() {
    return 'GLTFScene{nodes: $_nodesId}';
  }
}
