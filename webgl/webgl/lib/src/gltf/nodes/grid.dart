import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class GridGLTFNode extends GLTFNode{
  GridGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.grid(),
      name: name);
}