import 'dart:html';
import 'dart:typed_data' as WebGlTypedData;
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/debug_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_dictionnary.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
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

class EnableCapabilityType{
  final index;
  const EnableCapabilityType(this.index);

  static const EnableCapabilityType BLEND = const EnableCapabilityType(WebGL.RenderingContext.BLEND);
  static const EnableCapabilityType CULL_FACE = const EnableCapabilityType(WebGL.RenderingContext.CULL_FACE);
  static const EnableCapabilityType DEPTH_TEST = const EnableCapabilityType(WebGL.RenderingContext.DEPTH_TEST);
  static const EnableCapabilityType DITHER = const EnableCapabilityType(WebGL.RenderingContext.DITHER);
  static const EnableCapabilityType POLYGON_OFFSET_FILL = const EnableCapabilityType(WebGL.RenderingContext.POLYGON_OFFSET_FILL);
  static const EnableCapabilityType SAMPLE_ALPHA_TO_COVERAGE = const EnableCapabilityType(WebGL.RenderingContext.SAMPLE_ALPHA_TO_COVERAGE);
  static const EnableCapabilityType SAMPLE_COVERAGE = const EnableCapabilityType(WebGL.RenderingContext.SAMPLE_COVERAGE);
  static const EnableCapabilityType SCISSOR_TEST = const EnableCapabilityType(WebGL.RenderingContext.SCISSOR_TEST);
  static const EnableCapabilityType STENCIL_TEST = const EnableCapabilityType(WebGL.RenderingContext.STENCIL_TEST);
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

class DrawMode{
  final index;
  const DrawMode(this.index);

  static const DrawMode POINTS = const DrawMode(WebGL.RenderingContext.POINTS);
  static const DrawMode LINE_STRIP = const DrawMode(WebGL.RenderingContext.LINE_STRIP);
  static const DrawMode LINE_LOOP = const DrawMode(WebGL.RenderingContext.LINE_LOOP);
  static const DrawMode LINES = const DrawMode(WebGL.RenderingContext.LINES);
  static const DrawMode TRIANGLE_STRIP = const DrawMode(WebGL.RenderingContext.TRIANGLE_STRIP);
  static const DrawMode TRIANGLE_FAN = const DrawMode(WebGL.RenderingContext.TRIANGLE_FAN);
  static const DrawMode TRIANGLES = const DrawMode(WebGL.RenderingContext.TRIANGLES);
}

class ElementType{
  final index;
  const ElementType(this.index);

  static const ElementType UNSIGNED_BYTE = const ElementType(WebGL.RenderingContext.UNSIGNED_BYTE);
  static const ElementType UNSIGNED_SHORT = const ElementType(WebGL.RenderingContext.UNSIGNED_SHORT);
  //extension
}

class ReadPixelDataFormat{
  final index;
  const ReadPixelDataFormat(this.index);

  static const ReadPixelDataFormat ALPHA = const ReadPixelDataFormat(WebGL.RenderingContext.ALPHA);
  static const ReadPixelDataFormat RGB = const ReadPixelDataFormat(WebGL.RenderingContext.RGB);
  static const ReadPixelDataFormat RGBA = const ReadPixelDataFormat(WebGL.RenderingContext.RGBA);
}

class ReadPixelDataType{
  final index;
  const ReadPixelDataType(this.index);

  static const ReadPixelDataType UNSIGNED_BYTE = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_BYTE);
  static const ReadPixelDataType UNSIGNED_SHORT_5_6_5 = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5);
  static const ReadPixelDataType UNSIGNED_SHORT_4_4_4_4 = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4);
  static const ReadPixelDataType UNSIGNED_SHORT_5_5_5_1 = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1);
  static const ReadPixelDataType FLOAT = const ReadPixelDataType(WebGL.RenderingContext.FLOAT);
}

class DepthComparisonFunction{
  final index;
  const DepthComparisonFunction(this.index);

  static const DepthComparisonFunction NEVER = const DepthComparisonFunction(WebGL.RenderingContext.NEVER);
  static const DepthComparisonFunction LESS = const DepthComparisonFunction(WebGL.RenderingContext.LESS);
  static const DepthComparisonFunction EQUAL = const DepthComparisonFunction(WebGL.RenderingContext.EQUAL);
  static const DepthComparisonFunction LEQUAL = const DepthComparisonFunction(WebGL.RenderingContext.LEQUAL);
  static const DepthComparisonFunction GREATER = const DepthComparisonFunction(WebGL.RenderingContext.GREATER);
  static const DepthComparisonFunction NOTEQUAL = const DepthComparisonFunction(WebGL.RenderingContext.NOTEQUAL);
  static const DepthComparisonFunction GEQUAL = const DepthComparisonFunction(WebGL.RenderingContext.GEQUAL);
  static const DepthComparisonFunction ALWAYS = const DepthComparisonFunction(WebGL.RenderingContext.ALWAYS);
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

  bool get cullFace => ctx.isEnabled(EnableCapabilityType.CULL_FACE.index);
  set cullFace(bool enable){
    _enable(EnableCapabilityType.CULL_FACE, enable);
  }

  set cullFaceMode(CullFaceMode mode){
    ctx.cullFace(mode.index);
  }

  bool get depthTest => ctx.isEnabled(EnableCapabilityType.DEPTH_TEST.index);
  set depthTest(bool enable){
    _enable(EnableCapabilityType.DEPTH_TEST, enable);
  }

  bool get depthMask => getParameter(ContextParameter.DEPTH_WRITEMASK);
  set depthMask(bool enable){
      ctx.depthMask(enable);
  }

  DepthComparisonFunction get depthFunc => new DepthComparisonFunction(ctx.getParameter(ContextParameter.DEPTH_FUNC.index));
  set depthFunc(DepthComparisonFunction depthComparisionFunction){
    ctx.depthFunc(depthComparisionFunction.index);
  }

  num get drawingBufferWidth => ctx.drawingBufferWidth;
  num get drawingBufferHeight => ctx.drawingBufferHeight;

  WebGLRenderingContext._init(this.ctx);

  //Todo add default parameters
  factory WebGLRenderingContext.create(CanvasElement canvas,{bool debug : false, bool preserveDrawingBuffer:true}){
    WebGL.RenderingContext ctx;

    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    var options = {
      'preserveDrawingBuffer': preserveDrawingBuffer,
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
    int bitmask = 0;
    for(ClearBufferMask mask in masks) {
      bitmask |= mask.index;
    }
    ctx.clear(bitmask);
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

  Rectangle get viewport {
    Int32List values = ctx.getParameter(ContextParameter.VIEWPORT.index);
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set viewport(Rectangle rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    ctx.viewport(rect.left, rect.top, rect.width, rect.height);
  }

  Int32List get viewportDimensions => ctx.getParameter(ContextParameter.MAX_VIEWPORT_DIMS.index);

  void pixelStorei(PixelStorgeType storage, int value) {
    ctx.pixelStorei(storage.index, value);
  }


  void drawArrays(DrawMode mode, int firstVertexIndex, int vertexCount) {
    assert(firstVertexIndex >= 0 && vertexCount >= 0);
    ctx.drawArrays(mode.index, firstVertexIndex, vertexCount);
  }

  void drawElements(DrawMode mode, int count, ElementType type, int offset) {
    ctx.drawElements(mode.index, count, type.index, offset);
  }

  void texImage2DWithWidthAndHeight(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormatType internalFormat, int width, int height, int border, TextureInternalFormatType internalFormat2, TexelDataType texelDataType, WebGlTypedData.TypedData pixelsSource) {
    assert(width >= 0);
    assert(height >= 0);
    assert(internalFormat.index == internalFormat2.index);//in webgl1
    ctx.texImage2D(target.index, mipMapLevel, internalFormat.index, width, height, border, internalFormat2.index, texelDataType.index, pixelsSource);
  }

  void texImage2D(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormatType internalFormat, TextureInternalFormatType internalFormat2, TexelDataType texelDataType, pixelsSource) {
    assert(internalFormat.index == internalFormat2.index);//in webgl1
    assert(pixelsSource is ImageData || pixelsSource is ImageElement || pixelsSource is CanvasElement || pixelsSource is VideoElement || pixelsSource is ImageBitmap); //? add is null
    ctx.texImage2D(target.index, mipMapLevel, internalFormat.index, internalFormat2.index, texelDataType.index, pixelsSource);
  }

  void readPixels(int left, int top, int width, int height, ReadPixelDataFormat format, ReadPixelDataType type, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    ctx.readPixels(left, top, width, height, format.index, type.index, pixels);
  }

  void enable(EnableCapabilityType cap) {
    ctx.enable(cap.index);
  }
  void disable(EnableCapabilityType cap) {
    ctx.disable(cap.index);
  }

  void _enable(EnableCapabilityType enableCapType, bool enabled){
    if(enabled){
      enable(enableCapType);
    } else {
      disable(enableCapType);
    }
  }

  void isEnabled(EnableCapabilityType cap) {
    ctx.isEnabled(cap.index);
  }

  void depthRange(num zNear, num zFar) {
    ctx.depthRange(zNear, zFar);
  }

  void bindFrameBuffer(FrameBufferTarget target, WebGLFrameBuffer webGLframeBuffer) {
    ctx.bindFramebuffer(target.index, webGLframeBuffer.webGLFrameBuffer);
  }
}
