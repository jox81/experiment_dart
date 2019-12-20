import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class VectorGLTFNode extends GLTFNode{
  VectorGLTFNode(Vector3 vector3, {String name: ''}): super(
      mesh: new GLTFMesh.vector(vector3),
      name: name);
}