import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class PyramidGLTFNode extends GLTFNode{
  PyramidGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.pyramid(),
      name: name);
}