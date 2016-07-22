import 'dart:web_gl';
import 'application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'dart:html';

class TextureMap{

  RenderingContext get gl => Application.gl;

  Texture texture;

  TextureMap(ImageElement textureImage) {
    _createTexture(textureImage);
  }

  Texture _createTexture(ImageElement textureImage) {
    texture = gl.createTexture();
    gl.bindTexture(GL.TEXTURE_2D, texture);
    gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
    gl.texImage2D(
        GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, textureImage);
    gl.bindTexture(GL.TEXTURE_2D, null);

    return texture;
  }

  static initTexture(String fileName, Function callBack) {
    ImageElement image = new Element.tag('img');
    image.onLoad.listen((e) {
      TextureMap textureMap = new TextureMap(image);
      // callBack when texture is loaded
      callBack(textureMap);
    });
    image.src = fileName;
  }

}