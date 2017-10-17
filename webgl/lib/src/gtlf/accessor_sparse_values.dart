import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFAccessorSparseValues extends GltfProperty {
  glTF.AccessorSparseValues _gltfSource;
  glTF.AccessorSparseValues get gltfSource => _gltfSource;

  final int byteOffset;
  final GLTFBufferView bufferView;

  GLTFAccessorSparseValues(this.byteOffset, this.bufferView);

  GLTFAccessorSparseValues.fromGltf(
      this._gltfSource, )
      : this.byteOffset = _gltfSource.byteOffset,
        this.bufferView = new GLTFBufferView.fromGltf(_gltfSource.bufferView);

  @override
  String toString() {
    return 'GLTFAccessorSparseValues{byteOffset: $byteOffset, bufferView: $bufferView}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFAccessorSparseValues &&
              runtimeType == other.runtimeType &&
              byteOffset == other.byteOffset &&
              bufferView == other.bufferView;

  @override
  int get hashCode => byteOffset.hashCode ^ bufferView.hashCode;
}
