import 'dart:web_gl';
import 'dart:html';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'dart:async';
import 'package:webgl/src/globals/context.dart';

class TextureUtils {

  static Future<Texture> createTextureFromFile(String fileUrl) {
    Completer completer = new Completer();

    ImageElement image;

    image = new ImageElement()
      ..src = fileUrl
      ..onLoad.listen((e) {
        completer.complete(createTexture(image));
      });

    return completer.future;
  }

  // To use float :
  //  var ext = gl.getExtension("OES_texture_float");
  //  gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.FLOAT, textureImage);
  //  gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
  //  gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
  static Texture createTexture(ImageElement image) {
    Texture texture = gl.createTexture();
    gl.bindTexture(GL.TEXTURE_2D, texture);
    gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1);

    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);

    gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, image);

    gl.bindTexture(GL.TEXTURE_2D, null);

    return texture;
  }

  static Texture createRenderedTexture({int size: 512}) {

    Texture createTexture(int size) {
      //Texture
      Texture texture = gl.createTexture();
      gl.bindTexture(GL.TEXTURE_2D, texture);
      gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
      gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
//    gl.generateMipmap(GL.TEXTURE_2D);
      gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, size, size, 0, GL.RGBA,
          GL.UNSIGNED_BYTE, null);
      gl.bindTexture(GL.TEXTURE_2D, null);

      return texture;
    }

    Renderbuffer createRenderBuffer(int size) {
      Renderbuffer renderbuffer = gl.createRenderbuffer();
      gl.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);
      gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, size, size);
      gl.bindRenderbuffer(GL.RENDERBUFFER, null);
      return renderbuffer;
    }

    //Todo : Buffer vs Framebuffer vs Renderbuffer vs Texture ?
    // FrameBuffer contains Textures and RenderBuffers
    Framebuffer createFrameBuffer(Texture colorTexture, Renderbuffer depthRenderbuffer) {
      Framebuffer framebuffer = gl.createFramebuffer();
      gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

      gl.framebufferTexture2D(
          GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, colorTexture, 0);
      gl.framebufferRenderbuffer(
          GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, depthRenderbuffer);
      gl.bindFramebuffer(GL.FRAMEBUFFER, null);

      if (gl.checkFramebufferStatus(GL.FRAMEBUFFER) != GL.FRAMEBUFFER_COMPLETE) {
        print("createRenderBuffer : this combination of attachments does not work");
        return null;
      }

      return framebuffer;
    }

    Renderbuffer depthRenderbuffer = createRenderBuffer(size);
    Texture colorTexture = createTexture(size);
    Framebuffer framebuffer = createFrameBuffer(colorTexture, depthRenderbuffer);

    gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

    //Draw something to framebuffer
    //Each frameBuffer component ill be filled up
    gl.clearColor(0, 1, 0, 1); // green;
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    gl.bindFramebuffer(GL.FRAMEBUFFER, null);

    return colorTexture;
  }
}
