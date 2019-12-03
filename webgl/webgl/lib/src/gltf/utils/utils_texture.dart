import 'dart:html';
import 'dart:convert' show base64;
import 'dart:web_gl' as webgl;
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class UtilsTextureGLTF {
  static int initTextures(GLTFProject project) {

    WebGLTexture brdfLUTTexture, cubeMapTextureDiffuse, cubeMapTextureSpecular;

    ImageElement imageElement;
    ///TextureFilterType magFilter;
    int magFilter;
    /// TextureFilterType minFilter;
    int minFilter;
    /// TextureWrapType wrapS;
    int wrapS;
    /// TextureWrapType wrapT;
    int wrapT;

    //brdfLUT
    imageElement = AssetLibrary.project.brdfLUT;
    magFilter = TextureFilterType.LINEAR;
    minFilter = TextureFilterType.LINEAR;
    wrapS = TextureWrapType.REPEAT;
    wrapT = TextureWrapType.REPEAT;
    brdfLUTTexture = new WebGLTexture.fromWebGL(TextureUtils.createImageTexture(TextureUnit.TEXTURE0 + 0, imageElement, magFilter, minFilter, wrapS, wrapT), TextureTarget.TEXTURE_2D);
    brdfLUTTexture;//may be used ?

    //Environnement
    gl.activeTexture(TextureUnit.TEXTURE0 + 1);

    List<List<ImageElement>> papermill_diffuse = AssetLibrary.cubeMaps.papermillDiffuse;

    cubeMapTextureDiffuse = TextureUtils.createCubeMapFromImages(papermill_diffuse, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureDiffuse.webGLTexture);

    gl.activeTexture(TextureUnit.TEXTURE0 + 2);
    List<List<ImageElement>> papermill_specular = AssetLibrary.cubeMaps.papermillSpecular;
    cubeMapTextureSpecular = TextureUtils.createCubeMapFromImages(papermill_specular, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureSpecular.webGLTexture);

    int _reservedTextureUnits = 3;

    bool useDebugTexture = false;
    for (int i = 0; i < project.textures.length; i++) {
      int textureUnitId = 0;

      GLTFTexture gltfTexture;
      if (!useDebugTexture) {
        gltfTexture = project.textures[i];
        if (gltfTexture.source.data == null) {
          imageElement = project.getImage(gltfTexture.source.uri.toString());
          textureUnitId = gltfTexture.textureId;
        } else {
          String base64Encoded = base64.encode(gltfTexture.source.data);
          imageElement = new ImageElement(
              src: "data:${gltfTexture.source.mimeType};base64,$base64Encoded");
        }

        magFilter = gltfTexture.sampler != null
            ? gltfTexture.sampler.magFilter
            : TextureFilterType.LINEAR;
        minFilter = gltfTexture.sampler != null
            ? gltfTexture.sampler.minFilter
            : TextureFilterType.LINEAR;
        wrapS = gltfTexture.sampler != null
            ? gltfTexture.sampler.wrapS
            : TextureWrapType.REPEAT;
        wrapT = gltfTexture.sampler != null
            ? gltfTexture.sampler.wrapT
            : TextureWrapType.REPEAT;
      } else {
        imageElement = AssetLibrary.project.uvGrid;
        magFilter = TextureFilterType.LINEAR;
        minFilter = TextureFilterType.LINEAR;
        wrapS = TextureWrapType.CLAMP_TO_EDGE;
        wrapT = TextureWrapType.CLAMP_TO_EDGE;
      }

      //create model texture
      webgl.Texture texture = TextureUtils.createImageTexture(TextureUnit.TEXTURE0 + textureUnitId + _reservedTextureUnits, imageElement, magFilter, minFilter, wrapS, wrapT);
      if(gltfTexture != null){
        gltfTexture.webglTexture = texture;
      }
    }

    return _reservedTextureUnits;
  }
}