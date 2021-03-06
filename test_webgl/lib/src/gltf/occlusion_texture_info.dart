import 'package:test_webgl/src/gltf/texture.dart';
import 'package:test_webgl/src/gltf/texture_info.dart';

class GLTFOcclusionTextureInfo extends GLTFTextureInfo {
  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength):super(texCoord, texture : texture);

  @override
  String toString() {
    return 'GLTFOcclusionTextureInfo{strength: $strength} | ${super.toString()}';
  }
}