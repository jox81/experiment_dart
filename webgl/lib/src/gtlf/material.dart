import 'package:webgl/src/gtlf/normal_texture_info.dart';
import 'package:webgl/src/gtlf/occlusion_texture_info.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFPBRMaterial extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int materialId = nextId++;

  // Todo (jpu) : add other material objects, see spec.
  GLTFPbrMetallicRoughness pbrMetallicRoughness;
  GLTFNormalTextureInfo normalTexture;
  GLTFOcclusionTextureInfo occlusionTexture;

  GLTFTextureInfo emissiveTexture;
  List<double> emissiveFactor;

  //>
  String alphaMode;
  double alphaCutoff;
  bool doubleSided;

  GLTFPBRMaterial(
      {this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor : const[0.0, 0.0, 0.0],
      this.alphaMode = "OPAQUE",
      this.alphaCutoff : 0.5,
      this.doubleSided : false,
      String name: ''})
      : super(name);

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }
}
