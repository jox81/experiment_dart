import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/normal_texture_info.dart';
import 'package:webgl/src/gtlf/occlusion_texture_info.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFMaterial extends GLTFChildOfRootProperty {
  glTF.Material _gltfSource;
  glTF.Material get gltfSource => _gltfSource;

  // Todo (jpu) : add other material objects
  final GLTFPbrMetallicRoughness pbrMetallicRoughness;
  final GLTFNormalTextureInfo normalTexture;
  final GLTFOcclusionTextureInfo occlusionTexture;
  final GLTFTextureInfo emissiveTexture;

  //>
  final List<double> emissiveFactor;
  final String alphaMode;
  final double alphaCutoff;
  final bool doubleSided;

  GLTFMaterial._(this._gltfSource)
      : this.pbrMetallicRoughness = new GLTFPbrMetallicRoughness.fromGltf(
      _gltfSource.pbrMetallicRoughness),
        this.normalTexture = _gltfSource.normalTexture != null
            ? new GLTFNormalTextureInfo.fromGltf(_gltfSource.normalTexture)
            : null,
        this.occlusionTexture = _gltfSource.occlusionTexture != null
            ? new GLTFOcclusionTextureInfo.fromGltf(
            _gltfSource.occlusionTexture)
            : null,
        this.emissiveTexture = _gltfSource.emissiveTexture != null
            ? new GLTFTextureInfo.fromGltf(_gltfSource.emissiveTexture)
            : null,
        this.emissiveFactor = _gltfSource.emissiveFactor,
        this.alphaMode = _gltfSource.alphaMode,
        this.alphaCutoff = _gltfSource.alphaCutoff,
        this.doubleSided = _gltfSource.doubleSided;

  GLTFMaterial(
      this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor,
      this.alphaMode,
      this.alphaCutoff,
      this.doubleSided);

  factory GLTFMaterial.fromGltf(glTF.Material gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMaterial._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFMaterial &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              pbrMetallicRoughness == other.pbrMetallicRoughness &&
              normalTexture == other.normalTexture &&
              occlusionTexture == other.occlusionTexture &&
              emissiveTexture == other.emissiveTexture &&
              emissiveFactor == other.emissiveFactor &&
              alphaMode == other.alphaMode &&
              alphaCutoff == other.alphaCutoff &&
              doubleSided == other.doubleSided;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      pbrMetallicRoughness.hashCode ^
      normalTexture.hashCode ^
      occlusionTexture.hashCode ^
      emissiveTexture.hashCode ^
      emissiveFactor.hashCode ^
      alphaMode.hashCode ^
      alphaCutoff.hashCode ^
      doubleSided.hashCode;
}