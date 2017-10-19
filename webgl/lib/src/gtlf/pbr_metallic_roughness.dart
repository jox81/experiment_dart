import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFPbrMetallicRoughness extends GltfProperty {
  glTF.PbrMetallicRoughness _gltfSource;
  glTF.PbrMetallicRoughness get gltfSource => _gltfSource;

  final List<double> baseColorFactor;
  final GLTFTextureInfo baseColorTexture; // Todo (jpu) : Convert to linear flow

  final double metallicFactor;
  final double roughnessFactor;
  final GLTFTextureInfo
  metallicRoughnessTexture; // Todo (jpu) : Convert to linear flow

  GLTFPbrMetallicRoughness._(this._gltfSource)
      : this.baseColorFactor = _gltfSource.baseColorFactor,
        this.baseColorTexture =
        new GLTFTextureInfo.fromGltf(_gltfSource.baseColorTexture),
        this.metallicFactor = _gltfSource.metallicFactor,
        this.roughnessFactor = _gltfSource.roughnessFactor,
        this.metallicRoughnessTexture =
        new GLTFTextureInfo.fromGltf(_gltfSource.metallicRoughnessTexture);

  GLTFPbrMetallicRoughness(
      this.baseColorFactor,
      this.baseColorTexture,
      this.metallicFactor,
      this.roughnessFactor,
      this.metallicRoughnessTexture);

  factory GLTFPbrMetallicRoughness.fromGltf(
      glTF.PbrMetallicRoughness gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFPbrMetallicRoughness._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFPbrMetallicRoughness{baseColorFactor: $baseColorFactor, baseColorTexture: $baseColorTexture, metallicFactor: $metallicFactor, roughnessFactor: $roughnessFactor, metallicRoughnessTexture: $metallicRoughnessTexture}';
  }
}
