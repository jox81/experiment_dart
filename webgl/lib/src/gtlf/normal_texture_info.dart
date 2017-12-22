import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

class GLTFNormalTextureInfo extends GLTFTextureInfo {
  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale):super(texCoord, texture : texture);

  @override
  String toString() {
    return 'GLTFNormalTextureInfo{scale: $scale} | ${super.toString()}';
  }
}