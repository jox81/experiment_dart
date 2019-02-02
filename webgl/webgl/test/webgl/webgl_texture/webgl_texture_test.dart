import 'dart:html';
import "package:test/test.dart";
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

@TestOn("browser")

void main() {

  assetManager.useWebPath = true;

  CanvasElement canvas;
  Context context;

  setUp(() async {

    canvas = new Element.html('<canvas/>') as CanvasElement;
    canvas.width = 10;
    canvas.height = 10;

    context = new Context(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    context.clear();
    context = null;
    canvas = null;
  });

  group("Webgl Init", () {
    test("canvas test", () {
      expect(canvas, isNotNull);
    });
    test("gl test", () {
      expect(gl, isNotNull);
    });
  });

  group("Webgl ActiveTexture", () {
    test("Check ActiveTexture default activeUnit", () {
      expect(GL.activeTexture.activeTexture, equals(TextureUnit.TEXTURE0));
    });
    test("Check ActiveTexture activeUnit change", () {
      GL.activeTexture.activeTexture = TextureUnit.TEXTURE2;
      expect(GL.activeTexture.activeTexture, equals(TextureUnit.TEXTURE2));
    });

    test("activeTexture texture2d textureTarget", () {
      expect(GL.activeTexture.texture2d.textureTarget, equals(TextureTarget.TEXTURE_2D));
    });

    test("activeTexture textureCubeMap textureTarget", () {
      expect(GL.activeTexture.textureCubeMap.textureTarget, equals(TextureTarget.TEXTURE_CUBE_MAP));
    });
  });

  group("WebglTexture", () {

    // >> texture2d

    test("CTOR texture2d not bound", () {
      WebGLTexture texture = new WebGLTexture.texture2d();
      expect(texture, isNotNull);
      expect(texture.webGLTexture, isNotNull);
      expect(texture.isTexture, isFalse);
      expect(texture.textureTarget, equals(TextureTarget.TEXTURE_2D));
    });
    test("CTOR texture2d bound", () {
      WebGLTexture texture = new WebGLTexture.texture2d()
        ..bind();
      expect(texture, isNotNull);
      expect(texture.webGLTexture, isNotNull);
      expect(texture.isTexture, isTrue);
      expect(texture.textureTarget, equals(TextureTarget.TEXTURE_2D));
    });
    test("texture2d bind unbind test null", () {
      WebGLTexture texture = new WebGLTexture.texture2d();
      expect(GL.activeTexture.texture2d.boundTexture, isNull);

      GL.activeTexture.texture2d.bind(texture);
      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);

      GL.activeTexture.texture2d.unBind();
      expect(GL.activeTexture.texture2d.boundTexture, isNull);
    });

    // >> textureCubeMap

    test("CTOR textureCubeMap not bound", () {
      WebGLTexture texture = new WebGLTexture.textureCubeMap();
      expect(texture, isNotNull);
      expect(texture.webGLTexture, isNotNull);
      expect(texture.isTexture, isFalse);
      expect(texture.textureTarget, equals(TextureTarget.TEXTURE_CUBE_MAP));
    });
    test("CTOR textureCubeMap bound", () {
      WebGLTexture texture = new WebGLTexture.textureCubeMap()
        ..bind();
      expect(texture, isNotNull);
      expect(texture.webGLTexture, isNotNull);
      expect(texture.isTexture, isTrue);
      expect(texture.textureTarget, equals(TextureTarget.TEXTURE_CUBE_MAP));
    });
    test("textureCubeMap unbind test null", () {
      WebGLTexture texture = new WebGLTexture.textureCubeMap();
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNull);

      GL.activeTexture.textureCubeMap.bind(texture);
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNotNull);

      GL.activeTexture.textureCubeMap.unBind();
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNull);
    });
  });

  group("Both binding", () {

    // >> Both binding

    test("texture2d textureCubeMap bind unbind test null", () {
      WebGLTexture texture1 = new WebGLTexture.texture2d();
      WebGLTexture texture2 = new WebGLTexture.textureCubeMap();

      gl.activeTexture(TextureUnit.TEXTURE0);

      expect(GL.activeTexture.texture2d.boundTexture, isNull);
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNull);

      GL.activeTexture
        ..texture2d.bind(texture1);

      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNull);

      GL.activeTexture
        ..textureCubeMap.bind(texture2);

      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNotNull);

      GL.activeTexture
        ..texture2d.unBind()
        ..textureCubeMap.unBind();

      expect(GL.activeTexture.texture2d.boundTexture, isNull);
      expect(GL.activeTexture.textureCubeMap.boundTexture, isNull);
    });

    test("texture2d textureCubeMap wrong swap textureTarget", () {

      WebGLTexture texture = new WebGLTexture.texture2d();
      /// ErrorCode error;
      int error;

      gl.activeTexture(TextureUnit.TEXTURE0);
      GL.activeTexture
        ..texture2d.bind(texture)
        ..texture2d.unBind();
      error = gl.getError();
      expect(error, equals(ErrorCode.NO_ERROR));

      //Une fois une texture bindé à une TextureTarget, il n'est plus possible
      //de la binder à une autre TextureTarget
      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE1
        ..textureCubeMap.bind(texture);
      error = gl.getError();
      expect(error, equals(ErrorCode.INVALID_OPERATION));
    });

    test("texture binding to multiple TextureUnit", () {

      //une texture peut être bindé à différente TextureUnit en gardant le même TextureTarget

      WebGLTexture texture = new WebGLTexture.texture2d();

      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE0;
      expect(GL.activeTexture.texture2d.boundTexture, isNull);

      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE0
        ..texture2d.bind(texture);
      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);

      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE1
        ..texture2d.bind(texture);
      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);

      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE0;
      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);

      //Check same
      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE0;
      expect(GL.activeTexture.texture2d.boundTexture.webGLTexture, equals(texture.webGLTexture));
      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE1;
      expect(GL.activeTexture.texture2d.boundTexture.webGLTexture, equals(texture.webGLTexture));
    });

    test("une TextureTraget est simplement remplacée par un nouveau bind", () {

      WebGLTexture texture1 = new WebGLTexture.texture2d();
      WebGLTexture texture2 = new WebGLTexture.texture2d();

      GL.activeTexture
        ..activeTexture = TextureUnit.TEXTURE0;
      expect(GL.activeTexture.texture2d.boundTexture, isNull);

      GL.activeTexture
        ..texture2d.bind(texture1);
      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);

      GL.activeTexture
        ..texture2d.bind(texture2);
      expect(GL.activeTexture.texture2d.boundTexture, isNotNull);

      expect(GL.activeTexture.texture2d.boundTexture.webGLTexture, equals(texture2.webGLTexture));

    });

  });
}