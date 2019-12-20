import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class AxisPointGLTFNode extends GLTFNode{
  AxisPointGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.axisPoint(),
      name: name);
}