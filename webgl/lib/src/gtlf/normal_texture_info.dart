import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

class GLTFNormalTextureInfo extends GLTFTextureInfo {
  glTF.NormalTextureInfo _gltfSource;
  glTF.NormalTextureInfo get gltfSource => _gltfSource;

  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale):super(texCoord, texture);

  GLTFNormalTextureInfo._(glTF.NormalTextureInfo gltfSource)
      : this.scale = gltfSource.scale, super(gltfSource.texCoord, new GLTFTexture.fromGltf(gltfSource.texture));

  factory GLTFNormalTextureInfo.fromGltf(
      glTF.NormalTextureInfo gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFNormalTextureInfo._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFNormalTextureInfo{scale: $scale} | ${super.toString()}';
  }
}