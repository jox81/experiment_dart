import 'dart:async';
import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest = new WebglTest(querySelector('#glCanvas'));

  webglTest.setup();
}

class WebglTest {
  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  Future setup() async {
//    await simpleBindTest();
//    await bindUnbindTestNull();
//    await test03();
//    await wrongSwapTextureTarget();
//    await textureToMultipleTextureUnits();
//    await textureUnitWithBothTarget();
//    await textureUnitSwitchTexture();
//    await textureCubeMap();
    await testModifTexture();
  }

  Future simpleBindTest() async {
    gl.activeTexture.logActiveTextureInfo();

    WebGLTexture texture = new WebGLTexture();
    gl.activeTexture
      ..texture2d.bind(texture)
      ..logActiveTextureInfo();
  }

  Future bindUnbindTestNull() async {
    WebGLTexture texture = new WebGLTexture();

    assert(gl.activeTexture.texture2d.boundTexture == null);

    gl.activeTexture.texture2d.bind(texture);
    assert(gl.activeTexture.texture2d.boundTexture != null);

    gl.activeTexture.texture2d.unBind();
    assert(gl.activeTexture.texture2d.boundTexture == null);

    print('test ok');
  }

  Future test03() async {
    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = new WebGLTexture();

    gl.activeTexture..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0 //Default
      ..texture2d.bind(texture1)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..texture2d.bind(texture1)
      ..textureCubeMap.bind(texture2)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0 //Default
      ..texture2d.unBind()
      ..logActiveTextureInfo();
  }

  Future wrongSwapTextureTarget() async {
    print(
        '@ une fois une texture bindé à une TextureTarget, il n\'est plus possible de la binder à une autre TextureTarget');

    WebGLTexture texture = new WebGLTexture();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..texture2d.bind(texture)
      ..texture2d.unBind();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE1
      ..textureCubeMap.bind(texture);
    ;
  }

  Future textureToMultipleTextureUnits() async {
    print(
        '@ une texture peut être bindé à différente TextureUnit en gardant le même TextureTarget');

    WebGLTexture texture = new WebGLTexture();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..texture2d.bind(texture)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE1
      ..texture2d.bind(texture)
      ..logActiveTextureInfo();
  }

  Future textureUnitWithBothTarget() async {
    print(
        '@ une TextureUnit peut avoir ses deux TextureTarget bindés par des textures différentes');

    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = new WebGLTexture();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..texture2d.bind(texture1)
      ..textureCubeMap.bind(texture2)
      ..logActiveTextureInfo();
  }

  Future textureUnitSwitchTexture() async {
    print('@ une TextureTraget est simplement remplacée par un nouveau bind');

    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = TextureUtils.createColorTexture(64);

    gl.activeTexture..activeUnit = TextureUnit.TEXTURE0;

    gl.activeTexture
      ..texture2d.bind(texture1)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..texture2d.bind(texture2)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..texture2d.unBind()
      ..logActiveTextureInfo();
  }

  Future textureCubeMap() async {
    print('@ Test de loading d\'un cubemap');

    List<ImageElement> cubeMapImages =
        await TextureUtils.loadCubeMapImages('kitchen');
    WebGLTexture cubeMapTexture =
        TextureUtils.createCubeMapFromElements(cubeMapImages);
    gl.activeTexture.textureCubeMap.bind(cubeMapTexture);

    gl.activeTexture.logActiveTextureInfo();
  }

  Future testModifTexture() async {
    int size = 64;
    gl.activeTexture.activeUnit = TextureUnit.TEXTURE7;

    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = new WebGLTexture();

    void setupTexture1(WebGLTexture texture, int size) {
      gl.activeTexture.texture2d.bind(texture);

      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.NEAREST);
      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.NEAREST);
      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

      gl.activeTexture.texImage2DWithWidthAndHeight(
          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          size,
          size,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);

      gl.activeTexture.logActiveTextureInfo();
      gl.activeTexture.texture2d.unBind();
    }

    setupTexture1(texture1, size);

    void setupTexture2(WebGLTexture texture, int size) {
      gl.activeTexture.texture2d.bind(texture);

      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.LINEAR);
      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.LINEAR);
      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_S, TextureWrapType.REPEAT);
      gl.activeTexture.texture2d.setParameterInt(
          TextureParameter.TEXTURE_WRAP_T, TextureWrapType.REPEAT);

      gl.activeTexture.texImage2DWithWidthAndHeight(
          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          size,
          size,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);

      gl.activeTexture.logActiveTextureInfo();
      gl.activeTexture.texture2d.unBind();
    }

    setupTexture2(texture2, size);

    gl.activeTexture.texture2d.bind(texture1);
    gl.activeTexture.logActiveTextureInfo();
    gl.activeTexture.texture2d.unBind();
  }
}
