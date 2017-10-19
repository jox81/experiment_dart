import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

class GLTFOcclusionTextureInfo extends GLTFTextureInfo {
  glTF.NormalTextureInfo get gltfSource =>
      super.gltfSource as glTF.NormalTextureInfo;

  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength):super(texCoord, texture);

  GLTFOcclusionTextureInfo.fromGltf(glTF.OcclusionTextureInfo gltfSource)
      : this.strength = gltfSource.strength,
        super.fromGltf(gltfSource);

  @override
  String toString() {
    return 'GLTFOcclusionTextureInfo{strength: $strength} | ${super.toString()}';
  }
}