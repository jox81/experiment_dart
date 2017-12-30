import 'dart:typed_data';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFPbrMetallicRoughness extends GltfProperty {
  static int nextId = 0;
  final int materialPbrId = nextId++;

  List<double> baseColorFactor;
  GLTFTextureInfo baseColorTexture;

  double metallicFactor;
  double roughnessFactor;
  GLTFTextureInfo  metallicRoughnessTexture;

  GLTFPbrMetallicRoughness({
    this.baseColorFactor : const [1.0,1.0,1.0,1.0],
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
