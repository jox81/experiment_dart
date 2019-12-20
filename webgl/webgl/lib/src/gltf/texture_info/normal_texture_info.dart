import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/gltf/texture_info/texture_info.dart';
import 'package:webgl/src/introspection/introspection.dart';

//@reflector
class GLTFNormalTextureInfo extends GLTFTextureInfo {
  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale):super(texCoord, texture : texture);

  @override
  String toString() {
    return 'GLTFNormalTextureInfo{scale: $scale} | ${super.toString()}';
  }
}