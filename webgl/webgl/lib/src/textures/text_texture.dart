import 'dart:html';
import 'dart:web_gl';
import 'package:webgl/src/textures/text_style.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class TextTexture extends WebGLTexture{
  String text = '';

  int width;
  int height;
  TextStyle textStyle;

  /// create an offScreen canvas with a 2D canvas context to render text content
  CanvasRenderingContext2D  _ctxForMakingTextures = new CanvasElement().getContext("2d",{'alpha':true}) as CanvasRenderingContext2D;
  CanvasRenderingContext2D  get ctx => _ctxForMakingTextures;

  TextTexture(this.width, this.height):super.texture2d();

  void draw() {

    textStyle ??= new TextStyle();

    // make it a desired size
    ctx.canvas.width = width;
    ctx.canvas.height = height;

//    ctx.globalAlpha = textStyle.backgroundColor.a / 255.0;

    // fill it a certain color
    ctx.fillStyle = "rgb(${textStyle.backgroundColor.r.toInt()},${textStyle.backgroundColor.g.toInt()},${textStyle.backgroundColor.b.toInt()},${textStyle.backgroundColor.a.toInt()})";
    ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);

    // draw some text into it.
    ctx.fillStyle = "rgba(${textStyle.fillColor.r.toInt()},${textStyle.fillColor.g.toInt()}, ${textStyle.fillColor.b.toInt()}, ${textStyle.fillColor.a.toInt()})";
    ctx.font = "${textStyle.fontSize}px ${textStyle.fontFamily}";
    ctx.fillText(text, 0, height / 2 + textStyle.fontSize~/2, width);

    // Now make a texture from it
    bind();

    gl.texImage2D(TextureTarget.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, ctx.canvas);

    // generate mipmaps or set filtering
    gl.generateMipmap(WebGL.TEXTURE_2D);

    //detach texture, it will be re-used later
    gl.bindTexture(WebGL.TEXTURE_2D, null);
  }
}