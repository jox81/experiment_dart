import 'dart:html';
import 'dart:typed_data' as WebGlTypedData;
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/debug_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_dictionnary.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class TextureUnit {
  final index;
  const TextureUnit(this.index);

  static const TextureUnit TEXTURE0 = const TextureUnit(WebGL.RenderingContext.TEXTURE0);
  static const TextureUnit TEXTURE1 = const TextureUnit(WebGL.RenderingContext.TEXTURE1);
  static const TextureUnit TEXTURE2 = const TextureUnit(WebGL.RenderingContext.TEXTURE2);
  static const TextureUnit TEXTURE3 = const TextureUnit(WebGL.RenderingContext.TEXTURE3);
  static const TextureUnit TEXTURE4 = const TextureUnit(WebGL.RenderingContext.TEXTURE4);
  static const TextureUnit TEXTURE5 = const TextureUnit(WebGL.RenderingContext.TEXTURE5);
  static const TextureUnit TEXTURE6 = const TextureUnit(WebGL.RenderingContext.TEXTURE6);
  static const TextureUnit TEXTURE7 = const TextureUnit(WebGL.RenderingContext.TEXTURE7);
  static const TextureUnit TEXTURE8 = const TextureUnit(WebGL.RenderingContext.TEXTURE8);
  static const TextureUnit TEXTURE9 = const TextureUnit(WebGL.RenderingContext.TEXTURE9);
  static const TextureUnit TEXTURE10 = const TextureUnit(WebGL.RenderingContext.TEXTURE10);
  static const TextureUnit TEXTURE11 = const TextureUnit(WebGL.RenderingContext.TEXTURE11);
  static const TextureUnit TEXTURE12 = const TextureUnit(WebGL.RenderingContext.TEXTURE12);
  static const TextureUnit TEXTURE13 = const TextureUnit(WebGL.RenderingContext.TEXTURE13);
  static const TextureUnit TEXTURE14 = const TextureUnit(WebGL.RenderingContext.TEXTURE14);
  static const TextureUnit TEXTURE15 = const TextureUnit(WebGL.RenderingContext.TEXTURE15);
  static const TextureUnit TEXTURE16 = const TextureUnit(WebGL.RenderingContext.TEXTURE16);
  static const TextureUnit TEXTURE17 = const TextureUnit(WebGL.RenderingContext.TEXTURE17);
  static const TextureUnit TEXTURE18 = const TextureUnit(WebGL.RenderingContext.TEXTURE18);
  static const TextureUnit TEXTURE19 = const TextureUnit(WebGL.RenderingContext.TEXTURE19);
  static const TextureUnit TEXTURE20 = const TextureUnit(WebGL.RenderingContext.TEXTURE20);
  static const TextureUnit TEXTURE21 = const TextureUnit(WebGL.RenderingContext.TEXTURE21);
  static const TextureUnit TEXTURE22 = const TextureUnit(WebGL.RenderingContext.TEXTURE22);
  static const TextureUnit TEXTURE23 = const TextureUnit(WebGL.RenderingContext.TEXTURE23);
  static const TextureUnit TEXTURE24 = const TextureUnit(WebGL.RenderingContext.TEXTURE24);
  static const TextureUnit TEXTURE25 = const TextureUnit(WebGL.RenderingContext.TEXTURE25);
  static const TextureUnit TEXTURE26 = const TextureUnit(WebGL.RenderingContext.TEXTURE26);
  static const TextureUnit TEXTURE27 = const TextureUnit(WebGL.RenderingContext.TEXTURE27);
  static const TextureUnit TEXTURE28 = const TextureUnit(WebGL.RenderingContext.TEXTURE28);
  static const TextureUnit TEXTURE29 = const TextureUnit(WebGL.RenderingContext.TEXTURE29);
  static const TextureUnit TEXTURE30 = const TextureUnit(WebGL.RenderingContext.TEXTURE30);
  static const TextureUnit TEXTURE31 = const TextureUnit(WebGL.RenderingContext.TEXTURE31);
}

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

class PixelStorgeType{
  final index;
  const PixelStorgeType(this.index);

  static const PixelStorgeType PACK_ALIGNMENT = const PixelStorgeType(WebGL.RenderingContext.PACK_ALIGNMENT);
  static const PixelStorgeType UNPACK_ALIGNMENT = const PixelStorgeType(WebGL.RenderingContext.UNPACK_ALIGNMENT);
  static const PixelStorgeType UNPACK_FLIP_Y_WEBGL = const PixelStorgeType(WebGL.RenderingContext.UNPACK_FLIP_Y_WEBGL);
  static const PixelStorgeType UNPACK_PREMULTIPLY_ALPHA_WEBGL = const PixelStorgeType(WebGL.RenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL);
  static const PixelStorgeType UNPACK_COLORSPACE_CONVERSION_WEBGL = const PixelStorgeType(WebGL.RenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL);
}

class ContextParameter{
  final index;
  const ContextParameter(this.index);

  static const ContextParameter ACTIVE_TEXTURE = const ContextParameter(WebGL.RenderingContext.ACTIVE_TEXTURE);
  static const ContextParameter ALIASED_LINE_WIDTH_RANGE = const ContextParameter(WebGL.RenderingContext.ALIASED_LINE_WIDTH_RANGE);
  static const ContextParameter ALIASED_POINT_SIZE_RANGE = const ContextParameter(WebGL.RenderingContext.ALIASED_POINT_SIZE_RANGE);
  static const ContextParameter ALPHA_BITS = const ContextParameter(WebGL.RenderingContext.ARRAY_BUFFER_BINDING);
  static const ContextParameter BLEND = const ContextParameter(WebGL.RenderingContext.BLEND);
  static const ContextParameter BLEND_COLOR = const ContextParameter(WebGL.RenderingContext.BLEND_COLOR);
  static const ContextParameter BLEND_DST_ALPHA = const ContextParameter(WebGL.RenderingContext.BLEND_DST_ALPHA);
  static const ContextParameter BLEND_DST_RGB = const ContextParameter(WebGL.RenderingContext.BLEND_DST_RGB);
  static const ContextParameter BLEND_EQUATION = const ContextParameter(WebGL.RenderingContext.BLEND_EQUATION);
  static const ContextParameter BLEND_EQUATION_ALPHA = const ContextParameter(WebGL.RenderingContext.BLEND_EQUATION_ALPHA);
  static const ContextParameter BLEND_EQUATION_RGB = const ContextParameter(WebGL.RenderingContext.BLEND_EQUATION_RGB);
  static const ContextParameter BLEND_SRC_ALPHA = const ContextParameter(WebGL.RenderingContext.BLEND_SRC_ALPHA);
  static const ContextParameter BLEND_SRC_RGB = const ContextParameter(WebGL.RenderingContext.BLEND_SRC_RGB);
  static const ContextParameter BLUE_BITS = const ContextParameter(WebGL.RenderingContext.BLUE_BITS);
  static const ContextParameter COLOR_CLEAR_VALUE = const ContextParameter(WebGL.RenderingContext.COLOR_CLEAR_VALUE);
  static const ContextParameter COLOR_WRITEMASK = const ContextParameter(WebGL.RenderingContext.COLOR_WRITEMASK);
  static const ContextParameter COMPRESSED_TEXTURE_FORMATS = const ContextParameter(WebGL.RenderingContext.COMPRESSED_TEXTURE_FORMATS);
  static const ContextParameter CULL_FACE_MODE = const ContextParameter(WebGL.RenderingContext.CULL_FACE_MODE);
  static const ContextParameter CURRENT_PROGRAM = const ContextParameter(WebGL.RenderingContext.CURRENT_PROGRAM);
  static const ContextParameter DEPTH_BITS = const ContextParameter(WebGL.RenderingContext.DEPTH_BITS);
  static const ContextParameter DEPTH_CLEAR_VALUE = const ContextParameter(WebGL.RenderingContext.DEPTH_CLEAR_VALUE);
  static const ContextParameter DEPTH_FUNC = const ContextParameter(WebGL.RenderingContext.DEPTH_FUNC);
  static const ContextParameter DEPTH_RANGE = const ContextParameter(WebGL.RenderingContext.DEPTH_RANGE);
  static const ContextParameter DEPTH_TEST = const ContextParameter(WebGL.RenderingContext.DEPTH_TEST);
  static const ContextParameter DEPTH_WRITEMASK = const ContextParameter(WebGL.RenderingContext.DEPTH_WRITEMASK);
  static const ContextParameter DITHER = const ContextParameter(WebGL.RenderingContext.DITHER);
  static const ContextParameter ELEMENT_ARRAY_BUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER_BINDING);
  static const ContextParameter FRAMEBUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.FRAMEBUFFER_BINDING);
  static const ContextParameter FRONT_FACE = const ContextParameter(WebGL.RenderingContext.FRONT_FACE);
  static const ContextParameter GENERATE_MIPMAP_HINT = const ContextParameter(WebGL.RenderingContext.GENERATE_MIPMAP_HINT);
  static const ContextParameter IMPLEMENTATION_COLOR_READ_FORMAT = const ContextParameter(WebGL.RenderingContext.IMPLEMENTATION_COLOR_READ_FORMAT);
  static const ContextParameter IMPLEMENTATION_COLOR_READ_TYPE = const ContextParameter(WebGL.RenderingContext.IMPLEMENTATION_COLOR_READ_TYPE);
  static const ContextParameter LINE_WIDTH = const ContextParameter(WebGL.RenderingContext.LINE_WIDTH);
  static const ContextParameter MAX_COMBINED_TEXTURE_IMAGE_UNITS = const ContextParameter(WebGL.RenderingContext.MAX_COMBINED_TEXTURE_IMAGE_UNITS);
  static const ContextParameter MAX_CUBE_MAP_TEXTURE_SIZE = const ContextParameter(WebGL.RenderingContext.MAX_CUBE_MAP_TEXTURE_SIZE);
  static const ContextParameter MAX_FRAGMENT_UNIFORM_VECTORS = const ContextParameter(WebGL.RenderingContext.MAX_FRAGMENT_UNIFORM_VECTORS);
  static const ContextParameter MAX_RENDERBUFFER_SIZE = const ContextParameter(WebGL.RenderingContext.MAX_RENDERBUFFER_SIZE);
  static const ContextParameter MAX_TEXTURE_IMAGE_UNITS = const ContextParameter(WebGL.RenderingContext.MAX_TEXTURE_IMAGE_UNITS);
  static const ContextParameter MAX_TEXTURE_SIZE = const ContextParameter(WebGL.RenderingContext.MAX_TEXTURE_SIZE);
  static const ContextParameter MAX_VARYING_VECTORS = const ContextParameter(WebGL.RenderingContext.MAX_VARYING_VECTORS);
  static const ContextParameter MAX_VERTEX_ATTRIBS = const ContextParameter(WebGL.RenderingContext.MAX_VERTEX_ATTRIBS);
  static const ContextParameter MAX_VERTEX_TEXTURE_IMAGE_UNITS = const ContextParameter(WebGL.RenderingContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
  static const ContextParameter MAX_VERTEX_UNIFORM_VECTORS = const ContextParameter(WebGL.RenderingContext.MAX_VERTEX_UNIFORM_VECTORS);
  static const ContextParameter MAX_VIEWPORT_DIMS = const ContextParameter(WebGL.RenderingContext.MAX_VIEWPORT_DIMS);
  static const ContextParameter PACK_ALIGNMENT = const ContextParameter(WebGL.RenderingContext.PACK_ALIGNMENT);
  static const ContextParameter POLYGON_OFFSET_FACTOR = const ContextParameter(WebGL.RenderingContext.POLYGON_OFFSET_FACTOR);
  static const ContextParameter POLYGON_OFFSET_FILL = const ContextParameter(WebGL.RenderingContext.POLYGON_OFFSET_FILL);
  static const ContextParameter POLYGON_OFFSET_UNITS = const ContextParameter(WebGL.RenderingContext.POLYGON_OFFSET_UNITS);
  static const ContextParameter RED_BITS = const ContextParameter(WebGL.RenderingContext.RED_BITS);
  static const ContextParameter RENDERBUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.RENDERBUFFER_BINDING);
  static const ContextParameter RENDERER = const ContextParameter(WebGL.RenderingContext.RENDERER);
  static const ContextParameter SAMPLE_BUFFERS = const ContextParameter(WebGL.RenderingContext.SAMPLE_BUFFERS);
  static const ContextParameter SAMPLE_COVERAGE_INVERT = const ContextParameter(WebGL.RenderingContext.SAMPLE_COVERAGE_INVERT);
  static const ContextParameter SAMPLE_COVERAGE_VALUE = const ContextParameter(WebGL.RenderingContext.SAMPLE_COVERAGE_VALUE);
  static const ContextParameter SAMPLES = const ContextParameter(WebGL.RenderingContext.SAMPLES);
  static const ContextParameter SCISSOR_BOX = const ContextParameter(WebGL.RenderingContext.SCISSOR_BOX);
  static const ContextParameter SCISSOR_TEST = const ContextParameter(WebGL.RenderingContext.SCISSOR_TEST);
  static const ContextParameter SHADING_LANGUAGE_VERSION = const ContextParameter(WebGL.RenderingContext.SHADING_LANGUAGE_VERSION);
  static const ContextParameter STENCIL_BACK_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_FAIL);
  static const ContextParameter STENCIL_BACK_FUNC = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_FUNC);
  static const ContextParameter STENCIL_BACK_PASS_DEPTH_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_PASS_DEPTH_FAIL);
  static const ContextParameter STENCIL_BACK_PASS_DEPTH_PASS = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_PASS_DEPTH_PASS);
  static const ContextParameter STENCIL_BACK_REF = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_REF);
  static const ContextParameter STENCIL_BACK_VALUE_MASK = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_VALUE_MASK);
  static const ContextParameter STENCIL_BACK_WRITEMASK = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_WRITEMASK);
  static const ContextParameter STENCIL_BITS = const ContextParameter(WebGL.RenderingContext.STENCIL_BITS);
  static const ContextParameter STENCIL_CLEAR_VALUE = const ContextParameter(WebGL.RenderingContext.STENCIL_CLEAR_VALUE);
  static const ContextParameter STENCIL_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_FAIL);
  static const ContextParameter STENCIL_FUNC = const ContextParameter(WebGL.RenderingContext.STENCIL_FUNC);
  static const ContextParameter STENCIL_PASS_DEPTH_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_PASS_DEPTH_FAIL);
  static const ContextParameter STENCIL_PASS_DEPTH_PASS = const ContextParameter(WebGL.RenderingContext.STENCIL_PASS_DEPTH_PASS);
  static const ContextParameter STENCIL_REF = const ContextParameter(WebGL.RenderingContext.STENCIL_REF);
  static const ContextParameter STENCIL_TEST = const ContextParameter(WebGL.RenderingContext.STENCIL_TEST);
  static const ContextParameter STENCIL_VALUE_MASK = const ContextParameter(WebGL.RenderingContext.STENCIL_VALUE_MASK);
  static const ContextParameter STENCIL_WRITEMASK = const ContextParameter(WebGL.RenderingContext.STENCIL_WRITEMASK);
  static const ContextParameter SUBPIXEL_BITS = const ContextParameter(WebGL.RenderingContext.SUBPIXEL_BITS);
  static const ContextParameter TEXTURE_BINDING_2D = const ContextParameter(WebGL.RenderingContext.TEXTURE_BINDING_2D);
  static const ContextParameter TEXTURE_BINDING_CUBE_MAP = const ContextParameter(WebGL.RenderingContext.TEXTURE_BINDING_CUBE_MAP);
  static const ContextParameter UNPACK_ALIGNMENT = const ContextParameter(WebGL.RenderingContext.UNPACK_ALIGNMENT);
  static const ContextParameter UNPACK_COLORSPACE_CONVERSION_WEBGL = const ContextParameter(WebGL.RenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL);
  static const ContextParameter UNPACK_FLIP_Y_WEBGL = const ContextParameter(WebGL.RenderingContext.UNPACK_FLIP_Y_WEBGL);
  static const ContextParameter UNPACK_PREMULTIPLY_ALPHA_WEBGL = const ContextParameter(WebGL.RenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL);
  static const ContextParameter VENDOR = const ContextParameter(WebGL.RenderingContext.VENDOR);
  static const ContextParameter VERSION = const ContextParameter(WebGL.RenderingContext.VERSION);
  static const ContextParameter VIEWPORT = const ContextParameter(WebGL.RenderingContext.VIEWPORT);
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
  void bindTexture(TextureTarget target, WebGLTexture texture) {
    ctx.bindTexture(target.index, texture?.webGLTexture);
  }

  //RenderBuffer
  void bindRenderBuffer(RenderBufferTarget target, WebGLRenderBuffer renderBuffer) {
    ctx.bindRenderbuffer(target.index, renderBuffer?.webGLRenderBuffer);
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

  void activeTexture(TextureUnit textureUnit) {
    ctx.activeTexture(textureUnit.index);
  }

  dynamic getParameter(ContextParameter parameter){
    dynamic result =  ctx.getParameter(parameter.index);
    return result;
  }

  //Todo : get single parameter

  Int32List get viewport => ctx.getParameter(ContextParameter.VIEWPORT.index);
  void setViewport(int x, int y, num width, num height) {
    assert(width >= 0 && height >= 0);
    ctx.viewport(x, y, width, height);
  }

  Int32List get viewportDimensions => ctx.getParameter(ContextParameter.MAX_VIEWPORT_DIMS.index);

  void pixelStorei(PixelStorgeType storage, int value) {
    ctx.pixelStorei(storage.index, value);
  }
}
