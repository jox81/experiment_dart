import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFScene extends GLTFChildOfRootProperty {
  glTF.Scene _gltfSource;
  glTF.Scene get gltfSource => _gltfSource;

  int sceneId;

  final List<int> _nodesId = new List();
  List<GLTFNode> get nodes => gltfProject.nodes.where((n)=>_nodesId.contains(n.nodeId)).toList(growable: false);
  void addNode(GLTFNode node){
    assert(node != null);
    _nodesId.add(node.nodeId);
  }

  GLTFScene._(this._gltfSource);

  GLTFScene();

  factory GLTFScene.fromGltf(glTF.Scene gltfSource) {
    if (gltfSource == null) return null;
    GLTFScene scene = new GLTFScene._(gltfSource);
    for(glTF.Node node in gltfSource.nodes){
      GLTFNode gltfNode = new GLTFNode.fromGltf(node);

      int nodeId = gltfProject.nodes.indexOf(gltfNode);
      if(nodeId == -1){
        gltfProject.addNode(gltfNode);
      }else{
        gltfNode.nodeId = nodeId;
      }
      scene.addNode(gltfNode);
    }
    return scene;
  }

  @override
  String toString() {
    return 'GLTFScene{nodes: $_nodesId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFScene &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              nodes == other.nodes;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      nodes.hashCode;
}
