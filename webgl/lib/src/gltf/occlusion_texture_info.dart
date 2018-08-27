import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/gltf/texture_info.dart';
import 'package:webgl/src/introspection.dart';

@reflector
class GLTFOcclusionTextureInfo extends GLTFTextureInfo {
  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength):super(texCoord, texture : texture);

  @override
  String toString() {
    return 'GLTFOcclusionTextureInfo{strength: $strength} | ${super.toString()}';
  }
}