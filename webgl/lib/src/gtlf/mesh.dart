import 'package:collection/collection.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFMesh extends GLTFChildOfRootProperty {
  glTF.Mesh _gltfSource;
  glTF.Mesh get gltfSource => _gltfSource;

  int meshId;

  final List<GLTFMeshPrimitive> primitives;
  final List<double> weights;

  GLTFMesh._(this._gltfSource, [String name]):
      this.primitives = _gltfSource.primitives
      .map((p) => new GLTFMeshPrimitive.fromGltf(p))
      .toList(),
        this.weights = _gltfSource.weights != null
            ? (<double>[]..addAll(_gltfSource.weights))
            : <double>[], super(_gltfSource.name);

  factory GLTFMesh.fromGltf(glTF.Mesh gltfSource) {
    if (gltfSource == null) return null;
    GLTFMesh mesh = new GLTFMesh._(gltfSource);
    return mesh;
  }

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }
}