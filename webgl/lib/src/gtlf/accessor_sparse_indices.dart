import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFAccessorSparseIndices extends GltfProperty {
  glTF.AccessorSparseIndices _gltfSource;
  glTF.AccessorSparseIndices get gltfSource => _gltfSource;

  final int byteOffset;
  final ShaderVariableType componentType;

  GLTFAccessorSparseIndices(this.byteOffset, this.componentType);

  GLTFAccessorSparseIndices.fromGltf(
      this._gltfSource, )
      : this.byteOffset = _gltfSource.byteOffset,
        this.componentType =
        ShaderVariableType.getByIndex(_gltfSource.componentType);

  @override
  String toString() {
    return 'GLTFAccessorSparseIndices{byteOffset: $byteOffset, componentType: $componentType}';
  }
}