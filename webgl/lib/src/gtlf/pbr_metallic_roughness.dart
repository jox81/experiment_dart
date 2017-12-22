import 'dart:typed_data';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFPbrMetallicRoughness extends GltfProperty {
  static int nextId = 0;
  final int materialPbrId = nextId++;

  final Float32List baseColorFactor;
  final GLTFTextureInfo baseColorTexture; // Todo (jpu) : Convert to linear flow

  final double metallicFactor;
  final double roughnessFactor;
  final GLTFTextureInfo
  metallicRoughnessTexture; // Todo (jpu) : Convert to linear flow

  GLTFPbrMetallicRoughness({
    this.baseColorFactor,
    this.baseColorTexture,
    this.metallicFactor,
    this.roughnessFactor,
    this.metallicRoughnessTexture
  });

  @override
  String toString() {
    return 'GLTFPbrMetallicRoughness{baseColorFactor: $baseColorFactor, baseColorTexture: $baseColorTexture, metallicFactor: $metallicFactor, roughnessFactor: $roughnessFactor, metallicRoughnessTexture: $metallicRoughnessTexture}';
  }
}
