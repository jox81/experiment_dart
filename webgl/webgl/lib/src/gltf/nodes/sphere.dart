import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';

class SphereGLTFNode extends GLTFNode{
  SphereGLTFNode({String name: '', double radius : 1.0, int segmentV: 32, int segmentH: 32}): super(
      mesh: new GLTFMesh.sphere(radius: radius, segmentV: segmentV, segmentH: segmentH),
      name: name);
}