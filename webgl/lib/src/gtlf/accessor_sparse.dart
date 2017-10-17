import 'package:webgl/src/gtlf/accessor_sparse_indices.dart';
import 'package:webgl/src/gtlf/accessor_sparse_values.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:gltf/gltf.dart' as glTF;

class GLTFAccessorSparse extends GltfProperty {
  glTF.AccessorSparse _gltfSource;
  glTF.AccessorSparse get gltfSource => _gltfSource;

  final int count;
  final GLTFAccessorSparseIndices indices;
  final GLTFAccessorSparseValues values;

  GLTFAccessorSparse(this.count, this.indices, this.values);

  GLTFAccessorSparse.fromGltf(
      this._gltfSource, )
      : this.count = _gltfSource.count,
        this.indices = new GLTFAccessorSparseIndices.fromGltf(
            _gltfSource.indices),
        this.values = new GLTFAccessorSparseValues.fromGltf(_gltfSource.values);

  @override
  String toString() {
    return 'GLTFAccessorSparse{count: $count, indices: $indices, values: $values}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFAccessorSparse &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              count == other.count &&
              indices == other.indices &&
              values == other.values;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      count.hashCode ^
      indices.hashCode ^
      values.hashCode;
}
