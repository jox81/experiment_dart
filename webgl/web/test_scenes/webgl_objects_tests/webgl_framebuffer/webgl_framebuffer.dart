import 'dart:async';
import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_depth_texture/webgl_depth_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
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

  void setup() {
//    simpleBindTest();
//    bindUnbindTestNull();
//    createFrameBufferNoAttachment();
//    createFrameBufferColorAttachment();
    createFrameBufferDepthTextureAttachment();
//    createFrameBufferDepthBufferAttachment();
//    createFrameBufferStencilAttachment();
//    createFrameBuffer02();
//    createFrameBuffer03();
  }

  Future simpleBindTest() async {
    print('@ simple de test de binding');

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    glWrapper.activeFrameBuffer.bind(frameBuffer);
    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  Future bindUnbindTestNull() async {
    print('@ simple de test de binding/unbinding');

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();

    assert(glWrapper.activeFrameBuffer.boundFrameBuffer == null);

    glWrapper.activeFrameBuffer.bind(frameBuffer);
    assert(glWrapper.activeFrameBuffer.boundFrameBuffer != null);

    glWrapper.activeFrameBuffer.unBind();
    assert(glWrapper.activeFrameBuffer.boundFrameBuffer == null);

    print('test ok');
  }

  void createFrameBufferNoAttachment() {
    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();

    //Tant que le frameBuffer n'est pas bindé, il n'est pas vraiment initialisé
    glWrapper.activeFrameBuffer.bind(frameBuffer);
    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    //Il reste initialisé après être détaché
    glWrapper.activeFrameBuffer.unBind();
    frameBuffer.logFrameBufferInfos();
  }

  void createFrameBufferColorAttachment() {
    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    //The texture to bind must have a correct InternalFormatType
    WebGLTexture texture = new WebGLTexture.texture2d();
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        TextureInternalFormat.RGBA,
        64,
        64,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    glWrapper.activeFrameBuffer.bind(frameBuffer);
    glWrapper.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        texture,
        0);

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBufferDepthTextureAttachment() {
    //need extensions
    dynamic OES_texture_float = gl.getExtension('OES_texture_float');
    assert(OES_texture_float != null);

    dynamic WEBGL_depth_texture = gl.getExtension('WEBGL_depth_texture');
    assert(WEBGL_depth_texture != null);

    //
    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    glWrapper.activeFrameBuffer.bind(frameBuffer);

    //The texture to bind must have a correct InternalFormatType
    WebGLTexture texture = new WebGLTexture.texture2d();
    glWrapper.activeTexture.texture2d.bind(texture);
    glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT,
        64,
        64,
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT,
        WEBGL_depth_texture_TexelDataType.UNSIGNED_SHORT,
        null);

    glWrapper.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, TextureAttachmentTarget.TEXTURE_2D, texture, 0);

    glWrapper.activeTexture.logActiveTextureInfo();
    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBufferDepthBufferAttachment() {
    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    glWrapper.activeFrameBuffer.bind(frameBuffer);

    WebGLRenderBuffer depthRenderbuffer = new WebGLRenderBuffer();
    depthRenderbuffer.bind();
    depthRenderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.DEPTH_COMPONENT16, 64, 64);

    glWrapper.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, RenderBufferTarget.RENDERBUFFER, depthRenderbuffer);

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBufferStencilAttachment() {

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    glWrapper.activeFrameBuffer.bind(frameBuffer);

    WebGLRenderBuffer stencilRenderbuffer = new WebGLRenderBuffer();
    stencilRenderbuffer.bind();
    stencilRenderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.STENCIL_INDEX8, 64, 64);

    glWrapper.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.STENCIL_ATTACHMENT, RenderBufferTarget.RENDERBUFFER, stencilRenderbuffer);

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBuffer02() {
    int width = 64;
    int height = 64;

    // 1. Init Texture
    WebGLTexture texture = new WebGLTexture.texture2d();
    glWrapper.activeTexture.texture2d.bind(texture);
    try {
      glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//          TextureAttachmentTarget.TEXTURE_2D,
          0,
          TextureInternalFormat.RGBA,
          width,
          height,
          0,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          null);
    } catch (e) {
      // https://code.google.com/p/dart/issues/detail?id=11498
      Debug.log("gl.texImage2D: exception: $e", null);
    }

    // 2. Init Render Buffer
    WebGLRenderBuffer renderbuffer = new WebGLRenderBuffer();
    renderbuffer.bind();
    renderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER,
        RenderBufferInternalFormatType.DEPTH_COMPONENT16, width, height);

    // 3. Init Frame Buffer
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    glWrapper.activeFrameBuffer.bind(framebuffer);
    glWrapper.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        texture,
        0);
    glWrapper.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.DEPTH_ATTACHMENT,
        RenderBufferTarget.RENDERBUFFER,
        renderbuffer);

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    // 4. Clean up
    glWrapper.activeTexture.texture2d.unBind();
    renderbuffer.unBind();
    glWrapper.activeFrameBuffer.unBind();
  }

  void createFrameBuffer03() {
    int width = 64;
    int height = 64;

    // 1. Init Texture
    List<WebGLTexture> renderedTextures = TextureUtils.buildRenderedTextures();

    // 2. Init Render Buffer
    WebGLRenderBuffer renderbuffer = new WebGLRenderBuffer();

    renderbuffer.bind();
    renderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER,
        RenderBufferInternalFormatType.DEPTH_COMPONENT16, width, height);

    // 3. Init Frame Buffer
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    glWrapper.activeFrameBuffer.bind(framebuffer);
    glWrapper.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        renderedTextures[0],
        0);
    glWrapper.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.DEPTH_ATTACHMENT,
        RenderBufferTarget.RENDERBUFFER,
        renderbuffer);

    glWrapper.activeFrameBuffer.logActiveFrameBufferInfos();

    // 4. Clean up
    glWrapper.activeTexture.texture2d.unBind();
    renderbuffer.unBind();
    glWrapper.activeFrameBuffer.unBind();
  }
}
