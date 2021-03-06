import 'package:test_webgl/src/gltf/utils_gltf.dart';

class GLTFAccessorSparseIndices extends GltfProperty {
  final int byteOffset;
  /// ShaderVariableType componentType;
  final int componentType;

  GLTFAccessorSparseIndices(this.byteOffset, this.componentType);

  @override
  String toString() {
    return 'GLTFAccessorSparseIndices{byteOffset: $byteOffset, componentType: $componentType}';
  }
}