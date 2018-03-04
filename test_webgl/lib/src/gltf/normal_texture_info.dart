import 'package:test_webgl/src/gltf/texture.dart';
import 'package:test_webgl/src/gltf/texture_info.dart';

class GLTFNormalTextureInfo extends GLTFTextureInfo {
  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale):super(texCoord, texture : texture);

  @override
  String toString() {
    return 'GLTFNormalTextureInfo{scale: $scale} | ${super.toString()}';
  }
}