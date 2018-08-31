import 'package:webgl/src/gltf/utils_gltf.dart';
import 'package:webgl/src/introspection.dart';

@reflector
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