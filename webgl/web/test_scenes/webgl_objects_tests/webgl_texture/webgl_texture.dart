import 'dart:async';
import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest = new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {
  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  Future setup() async {
//    print('//////////////////////////////////////////////////////////////////');
//    await textureCubeMap();
//    await testModifTexture();
//    await testModifTextureInOtherUnit();
//    await testModifTextureInOtherUnitViaTexture();
  }

  Future textureCubeMap() async {
    print('@ Test de loading d\'un cubemap');

    List<ImageElement> cubeMapImages =
        await TextureUtils.loadCubeMapImages('kitchen');
    WebGLTexture cubeMapTexture =
        TextureUtils.createCubeMapWithImages(cubeMapImages);
    glWrapper.activeTexture.textureCubeMap.bind(cubeMapTexture);

    glWrapper.activeTexture.logActiveTextureInfo();
  }

  Future testModifTexture() async {
    int size = 64;
    gl.activeTexture(TextureUnit.TEXTURE7);

    WebGLTexture texture1 = new WebGLTexture.texture2d();
    WebGLTexture texture2 = new WebGLTexture.texture2d();

    void setupTexture1(WebGLTexture texture, int size) {
      glWrapper.activeTexture.texture2d.bind(texture);

      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.NEAREST);
      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.NEAREST);
      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

      glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          size,
          size,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);

      glWrapper.activeTexture.logActiveTextureInfo();
      glWrapper.activeTexture.texture2d.unBind();
    }

    setupTexture1(texture1, size);

    void setupTexture2(WebGLTexture texture, int size) {
      glWrapper.activeTexture.texture2d.bind(texture);

      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.LINEAR);
      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.LINEAR);
      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_S, TextureWrapType.REPEAT);
      glWrapper.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_T, TextureWrapType.REPEAT);

      glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          size,
          size,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);

      glWrapper.activeTexture.logActiveTextureInfo();
      glWrapper.activeTexture.texture2d.unBind();
    }

    setupTexture2(texture2, size);

    glWrapper.activeTexture.texture2d.bind(texture1);
    glWrapper.activeTexture.logActiveTextureInfo();
    glWrapper.activeTexture.texture2d.unBind();
  }

  Future testModifTextureInOtherUnit() async {

    WebGLTexture texture = new WebGLTexture.texture2d();

    //on initialize la texture et on set ses paramertes
    glWrapper.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MIN_FILTER,
    TextureMinificationFilterType.NEAREST);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MAG_FILTER,
    TextureMagnificationFilterType.NEAREST);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    int size = 64;
    glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);
    glWrapper.activeTexture.logActiveTextureInfo();
    glWrapper.activeTexture.texture2d.unBind();

    //on change de textureUnit pour la texture et on change quelques parametres
    glWrapper.activeTexture.activeTexture = TextureUnit.TEXTURE5;
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    glWrapper.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
    glWrapper.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.REPEAT);
    glWrapper.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.REPEAT);
    glWrapper.activeTexture.logActiveTextureInfo();
    glWrapper.activeTexture.texture2d.unBind();

    //on rechange de textureUnit et on vérifier les parametres
    glWrapper.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.logActiveTextureInfo();
  }

  Future testModifTextureInOtherUnitViaTexture() async {

    WebGLTexture texture = new WebGLTexture.texture2d();

    //on initialize la texture et on set ses paramertes
    glWrapper.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MIN_FILTER,
    TextureMinificationFilterType.NEAREST);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_MAG_FILTER,
    TextureMagnificationFilterType.NEAREST);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    glWrapper.activeTexture.texture2d.setParameterInt(
    TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    int size = 64;
    glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);
    glWrapper.activeTexture.logActiveTextureInfo();
    glWrapper.activeTexture.texture2d.unBind();

    //on change de methode pour la texture et on change quelques parametres
//    glWrapper.activeTexture.activeUnit = texture.editTextureUnit;
//    texture.bind();
    texture.textureWrapS = TextureWrapType.REPEAT;
    texture.textureWrapT = TextureWrapType.REPEAT;

    //on rechange de textureUnit et on vérifier les parametres
    glWrapper.activeTexture.activeTexture = TextureUnit.TEXTURE3;
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.logActiveTextureInfo();
  }
}
