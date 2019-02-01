import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/gltf/texture_info/normal_texture_info.dart';
import 'package:webgl/src/gltf/texture_info/occlusion_texture_info.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/texture_info/texture_info.dart';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
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
      : super(name){
    GLTFEngine.currentProject.materials.add(this);
  }

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }
}
