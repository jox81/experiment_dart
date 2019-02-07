import 'dart:html';
import 'dart:convert' show base64;
import 'dart:web_gl' as webgl;
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class UtilsTextureGLTF {
  static Future<int> initTextures(GLTFProject project) async {

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
    imageElement = await Engine.assetManager.loadImage('packages/webgl/images/utils/brdfLUT.png');
    magFilter = TextureFilterType.LINEAR;
    minFilter = TextureFilterType.LINEAR;
    wrapS = TextureWrapType.REPEAT;
    wrapT = TextureWrapType.REPEAT;
    brdfLUTTexture = new WebGLTexture.fromWebGL(TextureUtils.createImageTexture(TextureUnit.TEXTURE0 + 0, imageElement, magFilter, minFilter, wrapS, wrapT), TextureTarget.TEXTURE_2D);

    //Environnement
    gl.activeTexture(TextureUnit.TEXTURE0 + 1);
    List<List<ImageElement>> papermill_diffuse =
    await TextureUtils.loadCubeMapImages('papermill_diffuse', webPath: 'packages/webgl/');
    cubeMapTextureDiffuse = TextureUtils.createCubeMapFromImages(papermill_diffuse, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureDiffuse.webGLTexture);

    gl.activeTexture(TextureUnit.TEXTURE0 + 2);
    List<List<ImageElement>> papermill_specular =
    await TextureUtils.loadCubeMapImages('papermill_specular', webPath: 'packages/webgl/');
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
          //load image
          String fileUrl =
              project.baseDirectory + gltfTexture.source.uri.toString();
          imageElement = await Engine.assetManager.loadImage(fileUrl);
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
//        String imagePath = '/images/utils/uv.png';
        String imagePath = '/images/utils/uv_grid.png';
//      String imagePath = '/images/crate.gif';
//      String imagePath = '/gltf/samples/gltf_2_0/BoxTextured/CesiumLogoFlat.png';
//      String imagePath = '/gltf/samples/gltf_2_0/BoxTextured/CesiumLogoFlat_256.png';
        imageElement = await Engine.assetManager.loadImage(imagePath);

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