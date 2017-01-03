import 'dart:html';
import 'dart:typed_data' as WebGlTypedData;
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/debug_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_dictionnary.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class UsageType {
  final index;
  const UsageType(this.index);

  static const UsageType STATIC_DRAW =
      const UsageType(WebGL.RenderingContext.STATIC_DRAW);
  static const UsageType DYNAMIC_DRAW =
      const UsageType(WebGL.RenderingContext.DYNAMIC_DRAW);
  static const UsageType STREAM_DRAW =
      const UsageType(WebGL.RenderingContext.STREAM_DRAW);
}

class TextureTargetType{
  final index;
  const TextureTargetType(this.index);

  static const TextureTargetType TEXTURE_2D = const TextureTargetType(WebGL.RenderingContext.TEXTURE_2D);
  static const TextureTargetType TEXTURE_CUBE_MAP = const TextureTargetType(WebGL.RenderingContext.TEXTURE_CUBE_MAP);
}

class EnableCapType{
  final index;
  const EnableCapType(this.index);

  static const EnableCapType BLEND = const EnableCapType(WebGL.RenderingContext.BLEND);
  static const EnableCapType CULL_FACE = const EnableCapType(WebGL.RenderingContext.CULL_FACE);
  static const EnableCapType DEPTH_TEST = const EnableCapType(WebGL.RenderingContext.DEPTH_TEST);
  static const EnableCapType DITHER = const EnableCapType(WebGL.RenderingContext.DITHER);
  static const EnableCapType POLYGON_OFFSET_FILL = const EnableCapType(WebGL.RenderingContext.POLYGON_OFFSET_FILL);
  static const EnableCapType SAMPLE_ALPHA_TO_COVERAGE = const EnableCapType(WebGL.RenderingContext.SAMPLE_ALPHA_TO_COVERAGE);
  static const EnableCapType SAMPLE_COVERAGE = const EnableCapType(WebGL.RenderingContext.SAMPLE_COVERAGE);
  static const EnableCapType SCISSOR_TEST = const EnableCapType(WebGL.RenderingContext.SCISSOR_TEST);
  static const EnableCapType STENCIL_TEST = const EnableCapType(WebGL.RenderingContext.STENCIL_TEST);
}

class CullFaceMode{
  final index;
  const CullFaceMode(this.index);

  static const CullFaceMode FRONT = const CullFaceMode(WebGL.RenderingContext.FRONT);
  static const CullFaceMode BACK = const CullFaceMode(WebGL.RenderingContext.BACK);
  static const CullFaceMode FRONT_AND_BACK = const CullFaceMode(WebGL.RenderingContext.FRONT_AND_BACK);
}

class ClearBufferMask{
  final index;
  const ClearBufferMask(this.index);

  static const ClearBufferMask DEPTH_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.DEPTH_BUFFER_BIT);
  static const ClearBufferMask STENCIL_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.STENCIL_BUFFER_BIT);
  static const ClearBufferMask COLOR_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.COLOR_BUFFER_BIT);
}

class FaceMode{
  final index;
  const FaceMode(this.index);

  static const FaceMode CW = const FaceMode(WebGL.RenderingContext.CW);
  static const FaceMode CCW = const FaceMode(WebGL.RenderingContext.CCW);
}

class WebGLRenderingContext {

  WebGL.RenderingContext ctx;

  CanvasElement get canvas => ctx.canvas;

  Map get contextAttributes => (ctx.getContextAttributes() as WebGLDictionary).toMap;

  set frontFace(FaceMode mode){
    ctx.frontFace(mode.index);
  }

  bool get cullFace => ctx.isEnabled(EnableCapType.CULL_FACE.index);
  set cullFace(bool enable){
    _enable(EnableCapType.CULL_FACE, enable);
  }

  set cullFaceMode(CullFaceMode mode){
    ctx.cullFace(mode.index);
  }

  bool get depthTest => ctx.isEnabled(EnableCapType.DEPTH_TEST.index);
  set depthTest(bool enable){
    _enable(EnableCapType.DEPTH_TEST, enable);
  }

  void _enable(EnableCapType enableCapType, bool enabled){
    if(enabled){
      ctx.enable(enableCapType.index);
    } else {
      ctx.disable(enableCapType.index);
    }
  }

  num get drawingBufferWidth => ctx.drawingBufferWidth;
  num get drawingBufferHeight => ctx.drawingBufferHeight;

  WebGLRenderingContext._init(this.ctx);

  factory WebGLRenderingContext.create(CanvasElement canvas,{bool debug : false}){
    WebGL.RenderingContext ctx;

    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    var options = {
      'preserveDrawingBuffer': true,
    };

    for (int i = 0; i < names.length; ++i) {
      try {
        ctx = canvas.getContext(names[i], options); //Normal context
        if (debug) {
          ctx = new DebugRenderingContext(ctx);
        }
      } catch (e) {}
      if (ctx != null) {
        break;
      }
    }
    if (ctx == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }

    return new WebGLRenderingContext._init(ctx);

  }

  // Buffers
  void bindBuffer(BufferType bufferType, WebGLBuffer webglBuffer) {
    ctx.bindBuffer(bufferType.index, webglBuffer?.webGLBuffer);
  }

  void bufferData(BufferType bufferType,
      WebGlTypedData.TypedData typedData, UsageType usageType) {
    ctx.bufferData(bufferType.index, typedData, usageType.index);
  }

  void bufferDataWithSize(BufferType bufferType, int size,
      WebGLBuffer webglBuffer, UsageType usageType) {
    assert(size != null);
    ctx.bufferData(bufferType.index, size, usageType.index);
  }

  void bufferDataWithByteBuffer(BufferType bufferType,
      WebGlTypedData.ByteBuffer byteBuffer, UsageType usageType) {
    ctx.bufferData(bufferType.index, byteBuffer, usageType.index);
  }

  //Textures
  void bindTexture(TextureTargetType target, WebGLTexture texture) {
    ctx.bindTexture(target.index, texture?.webGLTexture);
  }

  //

  set clearColor(Vector4 color){
    ctx.clearColor(color.r, color.g, color.b, color.a);
  }

  void clear(List<ClearBufferMask> masks) {
    //Todo : change with bitmask : RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT
    for(ClearBufferMask mask in masks) {
      ctx.clear(mask.index);
    }
  }

  //Extensions
  List<String> get supportedExtensions => ctx.getSupportedExtensions();

  dynamic getExtension(String extensionName){
    return ctx.getExtension(extensionName);
  }


  Int32List get viewport => ctx.getParameter(WebGL.RenderingContext.MAX_VIEWPORT_DIMS);
  void setViewport(int x, int y, num width, num height) {
    assert(width >= 0 && height >= 0);
    ctx.viewport(x, y, width, height);
  }

  Int32List get viewportDimensions => ctx.getParameter(WebGL.RenderingContext.MAX_VIEWPORT_DIMS);

}
