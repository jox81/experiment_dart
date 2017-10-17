import 'package:collection/collection.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFMesh extends GLTFChildOfRootProperty {
  glTF.Mesh _gltfSource;
  glTF.Mesh get gltfSource => _gltfSource;

  int get meshId => null;// Todo (jpu) :

  final List<GLTFMeshPrimitive> primitives;
  final List<double> weights;

  GLTFMesh._(glTF.Mesh _gltfSource)
      : this.primitives = _gltfSource.primitives
      .map((p) => new GLTFMeshPrimitive.fromGltf(p))
      .toList(),
        this.weights = _gltfSource.weights != null
            ? (<double>[]..addAll(_gltfSource.weights))
            : <double>[];

  factory GLTFMesh.fromGltf(glTF.Mesh gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMesh._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFMesh &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              const ListEquality<GLTFMeshPrimitive>().equals(primitives, other.primitives) &&
              const ListEquality<double>().equals(weights, other.weights);

  @override
  int get hashCode =>
      _gltfSource.hashCode ^ primitives.hashCode ^ weights.hashCode;
}