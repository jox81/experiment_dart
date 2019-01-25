import 'package:webgl/src/gltf/accessor/accessor_sparse_indices.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse_values.dart';
import 'package:webgl/src/gltf/property/property.dart';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
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
