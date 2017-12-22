import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

class GLTFOcclusionTextureInfo extends GLTFTextureInfo {
  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength):super(texCoord, texture : texture);

  @override
  String toString() {
    return 'GLTFOcclusionTextureInfo{strength: $strength} | ${super.toString()}';
  }
}