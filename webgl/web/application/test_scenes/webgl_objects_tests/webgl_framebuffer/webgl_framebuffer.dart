import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
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

  void setup() {
//    createFrameBuffer01();
    createFrameBuffer02();
  }

  void createFrameBuffer01() {
       WebGLFrameBuffer frameBuffer1 = new WebGLFrameBuffer();
    frameBuffer1.logFrameBufferInfos();

    //Tant que le frameBuffer n'est pas bindé, il n'est pas vraiment initialisé
    frameBuffer1.bind();
    frameBuffer1.logFrameBufferInfos();

    //Il reste initialisé après être détaché
    frameBuffer1.unBind();
    frameBuffer1.logFrameBufferInfos();
  }

  void createFrameBuffer02() {
    int width = 64;
    int height = 64;

    // 1. Init Texture
    WebGLTexture texture = new WebGLTexture();
    texture.bind(TextureTarget.TEXTURE_2D);
    try {
      gl.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_2D, 0, TextureInternalFormatType.RGBA, width, height, 0, TextureInternalFormatType.RGBA, TexelDataType.UNSIGNED_BYTE, null);
    }
    catch (e) {
      // https://code.google.com/p/dart/issues/detail?id=11498
      Utils.log("gl.texImage2D: exception: $e", null);
    }

    // 2. Init Render Buffer
    WebGLRenderBuffer renderbuffer = new WebGLRenderBuffer();
    renderbuffer.bind();
    renderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.DEPTH_COMPONENT16, width, height);

    // 3. Init Frame Buffer
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    framebuffer.bind();
    texture.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, 0);
    renderbuffer.framebufferRenderbuffer(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, RenderBufferTarget.RENDERBUFFER );

    framebuffer.logFrameBufferInfos();

    // 4. Clean up
    texture.unBind(TextureTarget.TEXTURE_2D);
    renderbuffer.unBind();
    framebuffer.unBind();
  }

}
