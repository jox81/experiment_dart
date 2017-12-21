import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFMesh extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int meshId = nextId++;

  final List<GLTFMeshPrimitive> primitives;
  final List<double> weights;

  GLTFMesh({this.primitives, this.weights, String name: ''}) : super(name);

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }
}
