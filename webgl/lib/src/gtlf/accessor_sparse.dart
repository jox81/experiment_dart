import 'package:webgl/src/gtlf/accessor_sparse_indices.dart';
import 'package:webgl/src/gtlf/accessor_sparse_values.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/project.dart';

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
