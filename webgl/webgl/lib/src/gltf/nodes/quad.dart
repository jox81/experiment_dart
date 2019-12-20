import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class QuadGLTFNode extends GLTFNode{
  QuadGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.quad(),
      name: name);
}