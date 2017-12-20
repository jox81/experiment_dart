import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';

class GLTFAccessorSparseValues extends GltfProperty {
  glTF.AccessorSparseValues _gltfSource;
  glTF.AccessorSparseValues get gltfSource => _gltfSource;

  final int byteOffset;
  final GLTFBufferView bufferView;

  GLTFAccessorSparseValues(this.byteOffset, this.bufferView);

  GLTFAccessorSparseValues.fromGltf(
      this._gltfSource, )
      : this.byteOffset = _gltfSource.byteOffset,
        this.bufferView = gltfProject.getBufferView(_gltfSource.bufferView);

  @override
  String toString() {
    return 'GLTFAccessorSparseValues{byteOffset: $byteOffset, bufferView: $bufferView}';
  }

}
