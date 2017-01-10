import 'dart:async';
import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas'));

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  Future setup() async {
//    await simpleBindTexture2D();
//    await test02();
//    await test03();
//    await wrongSwapTextureTarget();
//    await textureToMultipleTextureUnits();
//    await textureUnitWithBothTarget();
    await textureUnitSwitchTexture();
  }

  Future simpleBindTexture2D() async {
    WebGLTexture texture = new WebGLTexture();
    gl.activeTexture
        ..bind(TextureTarget.TEXTURE_2D, texture)
        ..logActiveTextureInfo();
  }

  Future test02() async {
    WebGLTexture texture = new WebGLTexture();

    assert(gl.activeTexture.boundTexture2D == null);

    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);
    assert(gl.activeTexture.boundTexture2D != null);

    gl.activeTexture.unBind(TextureTarget.TEXTURE_2D);
    assert(gl.activeTexture.boundTexture2D == null);

  }

  Future test03() async {

    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = new WebGLTexture();

    gl.activeTexture
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0 //Default
      ..bind(TextureTarget.TEXTURE_2D, texture1)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..bind(TextureTarget.TEXTURE_2D, texture1)
      ..bind(TextureTarget.TEXTURE_CUBE_MAP, texture2)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0 //Default
      ..unBind(TextureTarget.TEXTURE_2D)
      ..logActiveTextureInfo();

  }

  Future wrongSwapTextureTarget() async {
    print('@ une fois une texture bindé à une TextureTarget, il n\'est plus possible de la binder à une autre TextureTarget');

    WebGLTexture texture = new WebGLTexture();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..bind(TextureTarget.TEXTURE_2D, texture)
      ..unBind(TextureTarget.TEXTURE_2D);

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE1
      ..bind(TextureTarget.TEXTURE_CUBE_MAP, texture);;
  }

  Future textureToMultipleTextureUnits() async {
    print('@ une texture peut être bindé à différente TextureUnit en gardant le même TextureTarget');

    WebGLTexture texture = new WebGLTexture();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..bind(TextureTarget.TEXTURE_2D, texture)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE1
      ..bind(TextureTarget.TEXTURE_2D, texture)
      ..logActiveTextureInfo();
  }

  Future textureUnitWithBothTarget() async {
    print('@ une TextureUnit peut avoir ses deux TextureTarget bindés par des textures différentes');

    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = new WebGLTexture();

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0
      ..bind(TextureTarget.TEXTURE_2D, texture1)
      ..bind(TextureTarget.TEXTURE_CUBE_MAP, texture2)
      ..logActiveTextureInfo();
  }

  Future textureUnitSwitchTexture() async {
    print('@ une TextureTraget est simplement remplacée par un nouveau bind');

    WebGLTexture texture1 = new WebGLTexture();
    WebGLTexture texture2 = TextureUtils.createColorTexture(64);

    gl.activeTexture
      ..activeUnit = TextureUnit.TEXTURE0;

    gl.activeTexture
      ..bind(TextureTarget.TEXTURE_2D, texture1)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..bind(TextureTarget.TEXTURE_2D, texture2)
      ..logActiveTextureInfo();

    gl.activeTexture
      ..unBind(TextureTarget.TEXTURE_2D)
      ..logActiveTextureInfo();
  }

}
