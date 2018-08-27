import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/utils_gltf.dart';
import 'package:webgl/src/introspection.dart';

@reflector
class GLTFAccessorSparseValues extends GltfProperty {
  final int byteOffset;
  final GLTFBufferView bufferView;

  GLTFAccessorSparseValues(this.byteOffset, this.bufferView);

  @override
  String toString() {
    return 'GLTFAccessorSparseValues{byteOffset: $byteOffset, bufferView: $bufferView}';
  }
}
