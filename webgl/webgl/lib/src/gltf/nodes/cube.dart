import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class CubeGLTFNode extends GLTFNode{
  CubeGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.cube(),
      name: name);
}