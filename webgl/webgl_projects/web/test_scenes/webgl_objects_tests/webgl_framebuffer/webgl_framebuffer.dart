import 'dart:async';
import 'dart:html';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/shaders/shader_sources.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_depth_texture/webgl_depth_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future main() async {
  ShaderSources shaderSources = new ShaderSources();
  await shaderSources.loadShaders();

  WebglTest webglTest = new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {
  WebglTest(CanvasElement canvas) {
    new Context(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {
//    simpleBindTest();
//    bindUnbindTestNull();
//    createFrameBufferNoAttachment();
    createFrameBufferColorAttachment();
//    createFrameBufferDepthTextureAttachment();
//    createFrameBufferDepthBufferAttachment();
//    createFrameBufferStencilAttachment();
//    createFrameBuffer02();
//    createFrameBuffer03();
  }

  Future simpleBindTest() async {
    print('@ simple de test de binding');

    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    GL.activeFrameBuffer.bind(frameBuffer);
    GL.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  Future bindUnbindTestNull() async {
    print('@ simple de test de binding/unbinding');

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();

    assert(GL.activeFrameBuffer.boundFrameBuffer == null);

    GL.activeFrameBuffer.bind(frameBuffer);
    assert(GL.activeFrameBuffer.boundFrameBuffer != null);

    GL.activeFrameBuffer.unBind();
    assert(GL.activeFrameBuffer.boundFrameBuffer == null);

    print('test ok');
  }

  void createFrameBufferNoAttachment() {
    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();

    //Tant que le frameBuffer n'est pas bindé, il n'est pas vraiment initialisé
    GL.activeFrameBuffer.bind(frameBuffer);
    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    //Il reste initialisé après être détaché
    GL.activeFrameBuffer.unBind();
    frameBuffer.logFrameBufferInfos();
  }

  void createFrameBufferColorAttachment() {
    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    //The texture to bind must have a correct InternalFormatType
    WebGLTexture texture = new WebGLTexture.texture2d();
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
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
    GL.activeFrameBuffer.bind(frameBuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        texture,
        0);

    GL.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBufferDepthTextureAttachment() {
    //need extensions
    dynamic OES_texture_float = gl.getExtension('OES_texture_float');
    assert(OES_texture_float != null);

    dynamic WEBGL_depth_texture = gl.getExtension('WEBGL_depth_texture');
    assert(WEBGL_depth_texture != null);

    //
    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    GL.activeFrameBuffer.bind(frameBuffer);

    //The texture to bind must have a correct InternalFormatType
    WebGLTexture texture = new WebGLTexture.texture2d();
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
//        TextureAttachmentTarget.TEXTURE_2D,
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT,
        64,
        64,
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT,
        WEBGL_depth_texture_TexelDataType.UNSIGNED_SHORT,
        null);

    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, TextureAttachmentTarget.TEXTURE_2D, texture, 0);

    GL.activeTexture.logActiveTextureInfo();
    GL.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBufferDepthBufferAttachment() {
    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    GL.activeFrameBuffer.bind(frameBuffer);

    WebGLRenderBuffer depthRenderbuffer = new WebGLRenderBuffer();
    depthRenderbuffer.bind();
    depthRenderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.DEPTH_COMPONENT16, 64, 64);

    GL.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, RenderBufferTarget.RENDERBUFFER, depthRenderbuffer);

    GL.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBufferStencilAttachment() {

    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    GL.activeFrameBuffer.bind(frameBuffer);

    WebGLRenderBuffer stencilRenderbuffer = new WebGLRenderBuffer();
    stencilRenderbuffer.bind();
    stencilRenderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.STENCIL_INDEX8, 64, 64);

    GL.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.STENCIL_ATTACHMENT, RenderBufferTarget.RENDERBUFFER, stencilRenderbuffer);

    GL.activeFrameBuffer.logActiveFrameBufferInfos();
  }

  void createFrameBuffer02() {
    int width = 64;
    int height = 64;

    // 1. Init Texture
    WebGLTexture texture = new WebGLTexture.texture2d();
    GL.activeTexture.texture2d.bind(texture);
    try {
      GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
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
    GL.activeFrameBuffer.bind(framebuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        texture,
        0);
    GL.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.DEPTH_ATTACHMENT,
        RenderBufferTarget.RENDERBUFFER,
        renderbuffer);

    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    // 4. Clean up
    GL.activeTexture.texture2d.unBind();
    renderbuffer.unBind();
    GL.activeFrameBuffer.unBind();
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

    GL.activeFrameBuffer.bind(framebuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        renderedTextures[0],
        0);
    GL.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.DEPTH_ATTACHMENT,
        RenderBufferTarget.RENDERBUFFER,
        renderbuffer);

    GL.activeFrameBuffer.logActiveFrameBufferInfos();

    // 4. Clean up
    GL.activeTexture.texture2d.unBind();
    renderbuffer.unBind();
    GL.activeFrameBuffer.unBind();
  }
}
