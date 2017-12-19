import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

class GLTFOcclusionTextureInfo extends GLTFTextureInfo {
  glTF.OcclusionTextureInfo _gltfSource;
  glTF.OcclusionTextureInfo get gltfSource => _gltfSource;

  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength):super(texCoord, texture : texture);

  GLTFOcclusionTextureInfo._(this._gltfSource)
      : this.strength = _gltfSource.strength, super(_gltfSource.texCoord, texture : gltfProject.createTexture(_gltfSource.texture));

  factory GLTFOcclusionTextureInfo.fromGltf(
      glTF.OcclusionTextureInfo gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFOcclusionTextureInfo._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFOcclusionTextureInfo{strength: $strength} | ${super.toString()}';
  }
}