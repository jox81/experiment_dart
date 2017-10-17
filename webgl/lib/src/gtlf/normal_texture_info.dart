import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

class GLTFNormalTextureInfo extends GLTFTextureInfo {
  glTF.NormalTextureInfo get gltfSource =>
      super.gltfSource as glTF.NormalTextureInfo;

  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale):super(texCoord, texture);

  GLTFNormalTextureInfo.fromGltf(glTF.NormalTextureInfo gltfSource)
      : this.scale = gltfSource.scale,
        super.fromGltf(gltfSource);

  @override
  String toString() {
    return 'GLTFNormalTextureInfo{scale: $scale} | ${super.toString()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is GLTFNormalTextureInfo &&
              runtimeType == other.runtimeType &&
              scale == other.scale;

  @override
  int get hashCode => super.hashCode ^ scale.hashCode;
}