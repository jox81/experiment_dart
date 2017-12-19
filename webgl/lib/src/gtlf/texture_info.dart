import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFTextureInfo extends GltfProperty {

  glTF.TextureInfo _gltfSource;
  glTF.TextureInfo get gltfSource => _gltfSource;

  int get index => texture.textureId;

  final int texCoord;

  int _textureId;
  GLTFTexture get texture => _textureId != null ? gltfProject.textures[_textureId] : null;

  GLTFTextureInfo(this.texCoord, {GLTFTexture texture}){
    if(texture != null){
      _textureId = texture.textureId;
    }
  }

  GLTFTextureInfo._(this._gltfSource)
      : this.texCoord = _gltfSource.texCoord;

  factory GLTFTextureInfo.fromGltf(glTF.TextureInfo gltfSource){
    if (gltfSource == null) return null;

    GLTFTextureInfo textureInfo =  new GLTFTextureInfo._(gltfSource);

    if(gltfSource.texture != null){
      GLTFTexture texture = gltfProject.getTexture(gltfSource.texture);
      textureInfo._textureId = texture.textureId;
    }

    return textureInfo;
  }

  @override
  String toString() {
    return 'GLTFTextureInfo{texCoord: $texCoord, texture: $texture}';
  }
}
