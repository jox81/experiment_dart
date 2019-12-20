import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class LineGLTFNode extends GLTFNode{
  LineGLTFNode(List<Vector3> points, {String name: ''}): super(
      mesh: new GLTFMesh.line(points),
      name: name);
}