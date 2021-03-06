import 'dart:async';
import 'dart:html';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future main() async {
  await AssetLibrary.shaders.loadAll();

  WebglTest webglTest = new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {
  WebglTest(CanvasElement canvas) {
    new Context(canvas, enableExtensions: true, logInfos: false);
  }

  Future setup() async {
//    print('//////////////////////////////////////////////////////////////////');
    await testEmptyTexture();
//    await textureCubeMap();
//    await testModifTexture();
//    await testModifTextureInOtherUnit();
//    await testModifTextureInOtherUnitViaTexture();
  }

  Future testEmptyTexture() async {
    gl.activeTexture(TextureUnit.TEXTURE7);

    WebGLTexture texture1 = new WebGLTexture.texture2d();

    GL.activeTexture.texture2d.bind(texture1);

    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

    GL.activeTexture.texture2d.attachmentTexture2d.texImage2D(
        0,
        TextureInternalFormat.RGBA,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);//This should not log an error !

    GL.activeTexture.logActiveTextureInfo();
    GL.activeTexture.texture2d.unBind();
  }

  Future textureCubeMap() async {
    print('@ Test de loading d\'un cubemap');

    List<List<ImageElement>> cubeMapImages =
    await AssetLibrary.cubeMaps.load(CubeMapName.kitchen);
    WebGLTexture cubeMapTexture =
    TextureUtils.createCubeMapFromImages(cubeMapImages);
    GL.activeTexture.textureCubeMap.bind(cubeMapTexture);

    GL.activeTexture.logActiveTextureInfo();

    gl.activeTexture(TextureUnit.TEXTURE5);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTexture.webGLTexture);

    GL.activeTexture.logActiveTextureInfo();
  }

  Future testModifTexture() async {
    int size = 64;
    gl.activeTexture(TextureUnit.TEXTURE7);

    WebGLTexture texture1 = new WebGLTexture.texture2d();
    WebGLTexture texture2 = new WebGLTexture.texture2d();

    void setupTexture1(WebGLTexture texture, int size) {
      GL.activeTexture.texture2d.bind(texture);

      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.NEAREST);
      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.NEAREST);
      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

      GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          size,
          size,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);

      GL.activeTexture.logActiveTextureInfo();
      GL.activeTexture.texture2d.unBind();
    }

    setupTexture1(texture1, size);

    void setupTexture2(WebGLTexture texture, int size) {
      GL.activeTexture.texture2d.bind(texture);

      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.LINEAR);
      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.LINEAR);
      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_S, TextureWrapType.REPEAT);
      GL.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_T, TextureWrapType.REPEAT);

      GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          size,
          size,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);

      GL.activeTexture.logActiveTextureInfo();
      GL.activeTexture.texture2d.unBind();
    }

    setupTexture2(texture2, size);

    GL.activeTexture.texture2d.bind(texture1);
    GL.activeTexture.logActiveTextureInfo();
    GL.activeTexture.texture2d.unBind();
  }

  Future testModifTextureInOtherUnit() async {

    WebGLTexture texture = new WebGLTexture.texture2d();

    //on initialize la texture et on set ses paramertes
    GL.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MIN_FILTER,
    TextureMinificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MAG_FILTER,
    TextureMagnificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    int size = 64;
    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);
    GL.activeTexture.logActiveTextureInfo();
    GL.activeTexture.texture2d.unBind();

    //on change de textureUnit pour la texture et on change quelques parametres
    GL.activeTexture.activeTexture = TextureUnit.TEXTURE5;
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.REPEAT);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.REPEAT);
    GL.activeTexture.logActiveTextureInfo();
    GL.activeTexture.texture2d.unBind();

    //on rechange de textureUnit et on vérifier les parametres
    GL.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.logActiveTextureInfo();
  }

  Future testModifTextureInOtherUnitViaTexture() async {

    WebGLTexture texture = new WebGLTexture.texture2d();

    //on initialize la texture et on set ses paramertes
    GL.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MIN_FILTER,
    TextureMinificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MAG_FILTER,
    TextureMagnificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    int size = 64;
    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);
    GL.activeTexture.logActiveTextureInfo();
    GL.activeTexture.texture2d.unBind();

    //on change de methode pour la texture et on change quelques parametres
//    GL.activeTexture.activeUnit = texture.editTextureUnit;
//    texture.bind();
    texture.textureWrapS = TextureWrapType.REPEAT;
    texture.textureWrapT = TextureWrapType.REPEAT;

    //on rechange de textureUnit et on vérifier les parametres
    GL.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.logActiveTextureInfo();
  }
}
