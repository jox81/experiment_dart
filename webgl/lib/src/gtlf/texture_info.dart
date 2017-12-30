import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

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

  static GLTFTextureInfo createTexture(GLTFProject project, String textureUrl) {
    GLTFSampler sampler = new GLTFSampler(
      magFilter: TextureFilterType.LINEAR,
      minFilter: TextureFilterType.LINEAR_MIPMAP_LINEAR,
      wrapS: TextureWrapType.MIRRORED_REPEAT,
      wrapT: TextureWrapType.MIRRORED_REPEAT,
    );
    project.samplers.add(sampler);

    GLTFImage image = new GLTFImage(
        uri: new Uri.file(textureUrl)
    );
    project.images.add(image);

    GLTFTexture texture = new GLTFTexture(
        sampler: sampler,
        source: image
    );
    project.textures.add(texture);

    GLTFTextureInfo textureInfo = new GLTFTextureInfo(0, texture: texture);
    return textureInfo;
  }
}
