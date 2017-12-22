import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFTextureInfo extends GltfProperty {
  int get index => texture.textureId;

  final int texCoord;

  GLTFTexture _texture;
  GLTFTexture get texture => _texture;
  set texture(GLTFTexture value) {
    _texture = value;
  }

  GLTFTextureInfo(this.texCoord, {GLTFTexture texture}){
    if(texture != null){
      _texture = texture;
    }
  }

  @override
  String toString() {
    return 'GLTFTextureInfo{texCoord: $texCoord, texture: $texture}';
  }
}
