import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFAccessorSparseValues extends GltfProperty {
  final int byteOffset;
  final GLTFBufferView bufferView;

  GLTFAccessorSparseValues(this.byteOffset, this.bufferView);

  @override
  String toString() {
    return 'GLTFAccessorSparseValues{byteOffset: $byteOffset, bufferView: $bufferView}';
  }
}
