import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class TriangleGLTFNode extends GLTFNode{
  TriangleGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.triangle(),
      name: name);
}