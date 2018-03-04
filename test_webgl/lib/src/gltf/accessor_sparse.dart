import 'package:test_webgl/src/gltf/accessor_sparse_indices.dart';
import 'package:test_webgl/src/gltf/accessor_sparse_values.dart';
import 'package:test_webgl/src/gltf/utils_gltf.dart';

class GLTFAccessorSparse extends GltfProperty {
  final int count;
  final GLTFAccessorSparseIndices indices;
  final GLTFAccessorSparseValues values;

  GLTFAccessorSparse(this.count, this.indices, this.values);

  @override
  String toString() {
    return 'GLTFAccessorSparse{count: $count, indices: $indices, values: $values}';
  }

}
