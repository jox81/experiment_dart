import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFTextureInfo extends GltfProperty {
  glTF.TextureInfo _gltfSource;
  glTF.TextureInfo get gltfSource => _gltfSource;

  final int texCoord;
  final GLTFTexture texture;

  GLTFTextureInfo(this.texCoord, this.texture);

  GLTFTextureInfo.fromGltf(this._gltfSource)
      : this.texCoord = _gltfSource.texCoord,
        this.texture = new GLTFTexture.fromGltf(_gltfSource.texture);

  @override
  String toString() {
    return 'GLTFTextureInfo{texCoord: $texCoord, texture: $texture}';
  }
}
