import 'dart:html';
import 'dart:typed_data' as WebGlTypedData;
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/debug_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_dictionnary.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
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

class EnableCapabilityType{
  final index;
  const EnableCapabilityType(this.index);

  static const EnableCapabilityType BLEND = const EnableCapabilityType(WebGL.RenderingContext.BLEND);
  static const EnableCapabilityType CULL_FACE = const EnableCapabilityType(WebGL.RenderingContext.CULL_FACE);
  static const EnableCapabilityType DEPTH_TEST = const EnableCapabilityType(WebGL.RenderingContext.DEPTH_TEST);
  static const EnableCapabilityType DITHER = const EnableCapabilityType(WebGL.RenderingContext.DITHER); //Todo : add enabling ?
  static const EnableCapabilityType POLYGON_OFFSET_FILL = const EnableCapabilityType(WebGL.RenderingContext.POLYGON_OFFSET_FILL);
  static const EnableCapabilityType SAMPLE_ALPHA_TO_COVERAGE = const EnableCapabilityType(WebGL.RenderingContext.SAMPLE_ALPHA_TO_COVERAGE);
  static const EnableCapabilityType SAMPLE_COVERAGE = const EnableCapabilityType(WebGL.RenderingContext.SAMPLE_COVERAGE);
  static const EnableCapabilityType SCISSOR_TEST = const EnableCapabilityType(WebGL.RenderingContext.SCISSOR_TEST);
  static const EnableCapabilityType STENCIL_TEST = const EnableCapabilityType(WebGL.RenderingContext.STENCIL_TEST);
}

class FacingType{
  final index;
  const FacingType(this.index);

  static const FacingType FRONT = const FacingType(WebGL.RenderingContext.FRONT);
  static const FacingType BACK = const FacingType(WebGL.RenderingContext.BACK);
  static const FacingType FRONT_AND_BACK = const FacingType(WebGL.RenderingContext.FRONT_AND_BACK);
}

class ClearBufferMask{
  final index;
  const ClearBufferMask(this.index);

  static const ClearBufferMask DEPTH_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.DEPTH_BUFFER_BIT);
  static const ClearBufferMask STENCIL_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.STENCIL_BUFFER_BIT);
  static const ClearBufferMask COLOR_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.COLOR_BUFFER_BIT);
}

class FrontFaceDirection{
  final index;
  const FrontFaceDirection(this.index);

  static const FrontFaceDirection CW = const FrontFaceDirection(WebGL.RenderingContext.CW);
  static const FrontFaceDirection CCW = const FrontFaceDirection(WebGL.RenderingContext.CCW);
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

class ComparisonFunction{
  final index;
  const ComparisonFunction(this.index);

  static const ComparisonFunction NEVER = const ComparisonFunction(WebGL.RenderingContext.NEVER);
  static const ComparisonFunction LESS = const ComparisonFunction(WebGL.RenderingContext.LESS);
  static const ComparisonFunction EQUAL = const ComparisonFunction(WebGL.RenderingContext.EQUAL);
  static const ComparisonFunction LEQUAL = const ComparisonFunction(WebGL.RenderingContext.LEQUAL);
  static const ComparisonFunction GREATER = const ComparisonFunction(WebGL.RenderingContext.GREATER);
  static const ComparisonFunction NOTEQUAL = const ComparisonFunction(WebGL.RenderingContext.NOTEQUAL);
  static const ComparisonFunction GEQUAL = const ComparisonFunction(WebGL.RenderingContext.GEQUAL);
  static const ComparisonFunction ALWAYS = const ComparisonFunction(WebGL.RenderingContext.ALWAYS);
}

class ErrorCode{
  final index;
  const ErrorCode(this.index);

  static const ErrorCode NO_ERROR = const ErrorCode(WebGL.RenderingContext.NO_ERROR);
  static const ErrorCode INVALID_ENUM = const ErrorCode(WebGL.RenderingContext.INVALID_ENUM);
  static const ErrorCode INVALID_VALUE = const ErrorCode(WebGL.RenderingContext.INVALID_VALUE);
  static const ErrorCode INVALID_OPERATION = const ErrorCode(WebGL.RenderingContext.INVALID_OPERATION);
  static const ErrorCode INVALID_FRAMEBUFFER_OPERATION = const ErrorCode(WebGL.RenderingContext.INVALID_FRAMEBUFFER_OPERATION);
  static const ErrorCode OUT_OF_MEMORY = const ErrorCode(WebGL.RenderingContext.OUT_OF_MEMORY);
  static const ErrorCode CONTEXT_LOST_WEBGL = const ErrorCode(WebGL.RenderingContext.CONTEXT_LOST_WEBGL);
}

class HintMode{
  final index;
  const HintMode(this.index);

  static const HintMode FASTEST = const HintMode(WebGL.RenderingContext.FASTEST);
  static const HintMode NICEST = const HintMode(WebGL.RenderingContext.NICEST);
  static const HintMode DONT_CARE = const HintMode(WebGL.RenderingContext.DONT_CARE);
}

class StencilOpMode{
  final index;
  const StencilOpMode(this.index);

  static const StencilOpMode ZERO = const StencilOpMode(WebGL.RenderingContext.ZERO);
  static const StencilOpMode KEEP = const StencilOpMode(WebGL.RenderingContext.KEEP);
  static const StencilOpMode REPLACE = const StencilOpMode(WebGL.RenderingContext.REPLACE);
  static const StencilOpMode INVERT = const StencilOpMode(WebGL.RenderingContext.INVERT);
  static const StencilOpMode INCR = const StencilOpMode(WebGL.RenderingContext.INCR);
  static const StencilOpMode INCR_WRAP = const StencilOpMode(WebGL.RenderingContext.INCR_WRAP);
  static const StencilOpMode DECR = const StencilOpMode(WebGL.RenderingContext.DECR);
  static const StencilOpMode DECR_WRAP = const StencilOpMode(WebGL.RenderingContext.DECR_WRAP);
}

class BlendFactorMode{
  final index;
  const BlendFactorMode(this.index);

  static const BlendFactorMode ZERO = const BlendFactorMode(WebGL.RenderingContext.ZERO);
  static const BlendFactorMode ONE = const BlendFactorMode(WebGL.RenderingContext.ONE);
  static const BlendFactorMode SRC_COLOR = const BlendFactorMode(WebGL.RenderingContext.SRC_COLOR);
  static const BlendFactorMode SRC_ALPHA = const BlendFactorMode(WebGL.RenderingContext.SRC_ALPHA);
  static const BlendFactorMode SRC_ALPHA_SATURATE = const BlendFactorMode(WebGL.RenderingContext.SRC_ALPHA_SATURATE);
  static const BlendFactorMode DST_COLOR = const BlendFactorMode(WebGL.RenderingContext.DST_COLOR);
  static const BlendFactorMode DST_ALPHA = const BlendFactorMode(WebGL.RenderingContext.DST_ALPHA);
  static const BlendFactorMode CONSTANT_COLOR = const BlendFactorMode(WebGL.RenderingContext.CONSTANT_COLOR);
  static const BlendFactorMode CONSTANT_ALPHA = const BlendFactorMode(WebGL.RenderingContext.CONSTANT_ALPHA);
  static const BlendFactorMode ONE_MINUS_SRC_COLOR = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_SRC_COLOR);
  static const BlendFactorMode ONE_MINUS_SRC_ALPHA = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_SRC_ALPHA);
  static const BlendFactorMode ONE_MINUS_DST_COLOR = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_DST_COLOR);
  static const BlendFactorMode ONE_MINUS_DST_ALPHA = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_DST_ALPHA);
  static const BlendFactorMode ONE_MINUS_CONSTANT_COLOR = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_CONSTANT_COLOR);
  static const BlendFactorMode ONE_MINUS_CONSTANT_ALPHA = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_CONSTANT_ALPHA);
}

class BlendFunctionMode{
  final index;
  const BlendFunctionMode(this.index);

  static const BlendFunctionMode FUNC_ADD = const BlendFunctionMode(WebGL.RenderingContext.FUNC_ADD);
  static const BlendFunctionMode FUNC_SUBTRACT = const BlendFunctionMode(WebGL.RenderingContext.FUNC_SUBTRACT);
  static const BlendFunctionMode FUNC_REVERSE_SUBTRACT = const BlendFunctionMode(WebGL.RenderingContext.FUNC_REVERSE_SUBTRACT);
}

class ContextParameter{
  final index;
  const ContextParameter(this.index);

  static const ContextParameter ACTIVE_TEXTURE = const ContextParameter(WebGL.RenderingContext.ACTIVE_TEXTURE);
  static const ContextParameter ALIASED_LINE_WIDTH_RANGE = const ContextParameter(WebGL.RenderingContext.ALIASED_LINE_WIDTH_RANGE);
  static const ContextParameter ALIASED_POINT_SIZE_RANGE = const ContextParameter(WebGL.RenderingContext.ALIASED_POINT_SIZE_RANGE);
  static const ContextParameter ALPHA_BITS = const ContextParameter(WebGL.RenderingContext.ALPHA_BITS);
  static const ContextParameter ARRAY_BUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.ARRAY_BUFFER_BINDING);
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
  static const ContextParameter GREEN_BITS = const ContextParameter(WebGL.RenderingContext.GREEN_BITS);
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

  Map get contextAttributes => (ctx.getContextAttributes() as WebGLDictionary).toMap;
  //
  bool get isContextLost => ctx.isContextLost();

  // >>> Parameteres
  dynamic getParameter(ContextParameter parameter){
    dynamic result =  ctx.getParameter(parameter.index);
    return result;
  }

  //>>> Todo : get single parameter

  // > ACTIVE_TEXTURE
  TextureUnit get activeTexture => new TextureUnit(ctx.getParameter(ContextParameter.ACTIVE_TEXTURE.index));
  set activeTexture(TextureUnit textureUnit) => ctx.activeTexture(textureUnit.index);

  // > ALIASED_LINE_WIDTH_RANGE [2]
  Float32List get aliasedLineWidthRange => ctx.getParameter(ContextParameter.ALIASED_LINE_WIDTH_RANGE.index);

  // > ALIASED_POINT_SIZE_RANGE [2]
  Float32List get aliasedPointSizeRange => ctx.getParameter(ContextParameter.ALIASED_POINT_SIZE_RANGE.index);

  // > RED_BITS
  int get redBits => ctx.getParameter(ContextParameter.RED_BITS.index);
  // > GREEN_BITS
  int get greenBits => ctx.getParameter(ContextParameter.GREEN_BITS.index);
  // > BLUE_BITS
  int get blueBits => ctx.getParameter(ContextParameter.BLUE_BITS.index);
  // > ALPHA_BITS
  int get alphaBits => ctx.getParameter(ContextParameter.ALPHA_BITS.index);
  // > DEPTH_BITS
  int get depthBits => ctx.getParameter(ContextParameter.DEPTH_BITS.index);
  // > STENCIL_BITS
  int get stencilBits => ctx.getParameter(ContextParameter.STENCIL_BITS.index);
  // > SUBPIXEL_BITS
  int get subPixelBits => ctx.getParameter(ContextParameter.SUBPIXEL_BITS.index);

  // > COLOR_CLEAR_VALUE [4]
  Vector4 get colorClearValue => new Vector4.fromFloat32List(ctx.getParameter(ContextParameter.COLOR_CLEAR_VALUE.index));

  // > COMPRESSED_TEXTURE_FORMATS [4]
  Int32List get compressTextureFormats => ctx.getParameter(ContextParameter.COMPRESSED_TEXTURE_FORMATS.index);

  // > CURRENT_PROGRAM
  WebGLProgram get currentProgram => new WebGLProgram.fromWebgl(ctx.getParameter(ContextParameter.CURRENT_PROGRAM.index));

  // > ARRAY_BUFFER_BINDING
  WebGLBuffer get arrayBufferBinding => new WebGLBuffer.fromWebgl(ctx.getParameter(ContextParameter.ARRAY_BUFFER_BINDING.index));
  // > ELEMENT_ARRAY_BUFFER_BINDING
  WebGLBuffer get elementArrayBufferBinding => new WebGLBuffer.fromWebgl(ctx.getParameter(ContextParameter.ELEMENT_ARRAY_BUFFER_BINDING.index));
  // > FRAMEBUFFER_BINDING
  WebGLFrameBuffer get frameBufferBinding => new WebGLFrameBuffer.fromWebgl(ctx.getParameter(ContextParameter.FRAMEBUFFER_BINDING.index));
  // > RENDERBUFFER_BINDING
  WebGLRenderBuffer get renderBufferBinding => new WebGLRenderBuffer.fromWebgl(ctx.getParameter(ContextParameter.RENDERBUFFER_BINDING.index));
  // > TEXTURE_BINDING_2D
  WebGLTexture get textureBinding2D => new WebGLTexture.fromWebgl(ctx.getParameter(ContextParameter.TEXTURE_BINDING_2D.index));
  // > TEXTURE_BINDING_CUBE_MAP
  WebGLTexture get textureBindingCubeMap => new WebGLTexture.fromWebgl(ctx.getParameter(ContextParameter.TEXTURE_BINDING_CUBE_MAP.index));

  // > FRONT_FACE
  FrontFaceDirection get frontFace => new FrontFaceDirection(ctx.getParameter(ContextParameter.FRONT_FACE.index));
  set frontFace(FrontFaceDirection mode) => ctx.frontFace(mode.index);

  // > MAX_TEXTURE_IMAGE_UNITS
  int get maxTextureImageUnits => ctx.getParameter(ContextParameter.MAX_TEXTURE_IMAGE_UNITS.index);
  // > MAX_COMBINED_TEXTURE_IMAGE_UNITS
  int get maxCombinedTextureImageUnits => ctx.getParameter(ContextParameter.MAX_COMBINED_TEXTURE_IMAGE_UNITS.index);
  // > MAX_CUBE_MAP_TEXTURE_SIZE
  int get maxCubeMapTextureSize => ctx.getParameter(ContextParameter.MAX_CUBE_MAP_TEXTURE_SIZE.index);
  // > MAX_TEXTURE_SIZE
  int get maxTextureSize => ctx.getParameter(ContextParameter.MAX_TEXTURE_SIZE.index);

  // > MAX_VERTEX_TEXTURE_IMAGE_UNITS
  int get maxVertexTextureImageUnits => ctx.getParameter(ContextParameter.MAX_VERTEX_TEXTURE_IMAGE_UNITS.index);

  // > MAX_VERTEX_ATTRIBS
  int get maxVertexAttributs => ctx.getParameter(ContextParameter.MAX_VERTEX_ATTRIBS.index);
  // > MAX_VERTEX_UNIFORM_VECTORS
  int get maxVertexUnifromVectors => ctx.getParameter(ContextParameter.MAX_VERTEX_UNIFORM_VECTORS.index);
  // > MAX_VARYING_VECTORS
  int get maxVaryingVectors => ctx.getParameter(ContextParameter.MAX_VARYING_VECTORS.index);
  // > MAX_FRAGMENT_UNIFORM_VECTORS
  int get maxFragmentUnifromVectors => ctx.getParameter(ContextParameter.MAX_FRAGMENT_UNIFORM_VECTORS.index);

  // > MAX_RENDERBUFFER_SIZE
  int get maxRenderBufferSize => ctx.getParameter(ContextParameter.MAX_RENDERBUFFER_SIZE.index);

  // > RENDERER
  String get renderer => ctx.getParameter(ContextParameter.RENDERER.index);
  // > VERSION
  String get version => ctx.getParameter(ContextParameter.VERSION.index);
  // > SHADING_LANGUAGE_VERSION
  String get shadingLanguageVersion => ctx.getParameter(ContextParameter.SHADING_LANGUAGE_VERSION.index);
  // > VENDOR
  String get vendor => ctx.getParameter(ContextParameter.VENDOR.index);

  // > SAMPLES
  int get samples => ctx.getParameter(ContextParameter.SAMPLES.index);
  // > SAMPLE_BUFFERS
  int get sampleBuffers => ctx.getParameter(ContextParameter.SAMPLE_BUFFERS.index);

  // > STENCIL_FAIL
  StencilOpMode get stencilFail => new StencilOpMode(ctx.getParameter(ContextParameter.STENCIL_FAIL.index));
  // > STENCIL_PASS_DEPTH_PASS
  StencilOpMode get stencilPassDepthPass => new StencilOpMode(ctx.getParameter(ContextParameter.STENCIL_PASS_DEPTH_PASS.index));
  // > STENCIL_PASS_DEPTH_FAIL
  StencilOpMode get stencilPassDepthFail => new StencilOpMode(ctx.getParameter(ContextParameter.STENCIL_PASS_DEPTH_FAIL.index));
  // > STENCIL_BACK_FAIL
  StencilOpMode get stencilBackFail => new StencilOpMode(ctx.getParameter(ContextParameter.STENCIL_BACK_FAIL.index));
  // > STENCIL_BACK_PASS_DEPTH_PASS
  StencilOpMode get stencilBackPassDepthPass => new StencilOpMode(ctx.getParameter(ContextParameter.STENCIL_BACK_PASS_DEPTH_PASS.index));
  // > STENCIL_BACK_PASS_DEPTH_FAIL
  StencilOpMode get stencilBackPassDepthFail => new StencilOpMode(ctx.getParameter(ContextParameter.STENCIL_BACK_PASS_DEPTH_FAIL.index));

  // > UNPACK_ALIGNMENT
  int get unpackAlignment => ctx.getParameter(ContextParameter.UNPACK_ALIGNMENT.index);

  // > UNPACK_COLORSPACE_CONVERSION_WEBGL
  PixelStorgeType get unpackColorSpaceConversionWebGL => new PixelStorgeType(ctx.getParameter(ContextParameter.UNPACK_COLORSPACE_CONVERSION_WEBGL.index));
  // > UNPACK_FLIP_Y_WEBGL
  bool get unpackFlipYWebGL => ctx.getParameter(ContextParameter.UNPACK_FLIP_Y_WEBGL.index);
  // > UNPACK_PREMULTIPLY_ALPHA_WEBGL
  bool get unpackPreMultiplyAlphaWebGL => ctx.getParameter(ContextParameter.UNPACK_PREMULTIPLY_ALPHA_WEBGL.index);





  //>>>




  //CullFace
  // > CULL_FACE //Todo : ? identique à get parameter ? BLEND
  bool get cullFace => isEnabled(EnableCapabilityType.CULL_FACE.index);
  set cullFace(bool enable) => _setEnabled(EnableCapabilityType.CULL_FACE, enable);

  // > CULL_FACE_MODE
  FacingType get cullFaceMode => new FacingType(ctx.getParameter(ContextParameter.CULL_FACE_MODE.index));
  set cullFaceMode(FacingType mode) => ctx.cullFace(mode.index);

  //Depth
  // > DEPTH_TEST
  bool get depthTest => ctx.isEnabled(EnableCapabilityType.DEPTH_TEST.index);
  set depthTest(bool enable) => _setEnabled(EnableCapabilityType.DEPTH_TEST, enable);

  // > DEPTH_WRITEMASK
  bool get depthMask => ctx.getParameter(ContextParameter.DEPTH_WRITEMASK.index);
  set depthMask(bool enable) => ctx.depthMask(enable);

  // > DEPTH_FUNC
  ComparisonFunction get depthFunc => new ComparisonFunction(ctx.getParameter(ContextParameter.DEPTH_FUNC.index));
  set depthFunc(ComparisonFunction depthComparisionFunction) => ctx.depthFunc(depthComparisionFunction.index);

  // > DEPTH_RANGE [2]
  Float32List get depthRange => ctx.getParameter(ContextParameter.DEPTH_RANGE.index);
  void setDepthRange(num zNear, num zFar) {
    ctx.depthRange(zNear, zFar);
  }

  // > DEPTH_CLEAR_VALUE
  num get clearDepth => ctx.getParameter(ContextParameter.DEPTH_CLEAR_VALUE.index);
  set clearDepth(num depthValue){
    assert(0.0 <= depthValue && depthValue <= 1.0);
    ctx.clearDepth(depthValue);
  }

  //Scissor
  // > SCISSOR_BOX
  Rectangle get scissor {
    Int32List values = ctx.getParameter(ContextParameter.SCISSOR_BOX.index);
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set scissor(Rectangle rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    ctx.scissor(rect.left, rect.top, rect.width, rect.height);
  }

  // > SCISSOR_TEST
  bool get scissorTest => isEnabled(EnableCapabilityType.SCISSOR_TEST);
  set scissorTest(bool enabled) => _setEnabled(EnableCapabilityType.SCISSOR_TEST, enabled);

  // > LINE_WIDTH
  num get lineWidth => ctx.getParameter(ContextParameter.LINE_WIDTH.index);
  set lineWidth(num width) => ctx.lineWidth(width);

  //Polygon offset
  // > POLYGON_OFFSET_FILL
  bool get polygonOffset => ctx.isEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL.index);
  set polygonOffset(bool enabled) =>_setEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL, enabled);

  // > POLYGON_OFFSET_FACTOR
  num get polygonOffsetFactor => ctx.getParameter(ContextParameter.POLYGON_OFFSET_FACTOR.index);
  // > POLYGON_OFFSET_UNITS
  num get polygonOffsetUnits => ctx.getParameter(ContextParameter.POLYGON_OFFSET_UNITS.index);

  void setPolygonOffest(num factor, num units){
    ctx.polygonOffset(factor, units);
  }

  //MultiSampleCoverage
  bool get sampleCovarage => isEnabled(EnableCapabilityType.SAMPLE_COVERAGE);
  set sampleCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_COVERAGE, enabled);

  bool get sampleAlphaToCoverage => isEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE);
  set sampleAlphaToCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE, enabled);

  // > SAMPLE_COVERAGE_VALUE
  num get sampleCoverageValue => ctx.getParameter(ContextParameter.SAMPLE_COVERAGE_VALUE.index);
  // > SAMPLE_COVERAGE_INVERT
  bool get sampleCoverageInvert => ctx.getParameter(ContextParameter.SAMPLE_COVERAGE_INVERT.index);
  void setSampleCoverage(num value, bool invert) => ctx.sampleCoverage(value, invert);

  //Stencils
  bool get stencilTest => isEnabled(EnableCapabilityType.STENCIL_TEST);
  set stencilTest (bool enabled) => _setEnabled(EnableCapabilityType.STENCIL_TEST, enabled);

  void stencilFunc(ComparisonFunction comparisonFunction, int ref, int mask){
    ctx.stencilFunc(comparisonFunction.index, ref, mask);
  }
  void stencilFuncSeparate(FacingType faceType, ComparisonFunction comparisonFunction, int ref, int mask){
    ctx.stencilFuncSeparate(faceType.index, comparisonFunction.index, ref, mask);
  }
  void stencilMaskSeparate(FacingType faceType, int mask){
    ctx.stencilMaskSeparate(faceType.index, mask);
  }
  void stencilOp(StencilOpMode fail, StencilOpMode zFail, StencilOpMode zPass){
    ctx.stencilOp(fail.index, zFail.index, zPass.index);
  }
  void stencilOpSeparate(FacingType faceType, StencilOpMode fail, StencilOpMode zFail, StencilOpMode zPass){
    ctx.stencilOpSeparate(faceType.index, fail.index, zFail.index, zPass.index);
  }
  int get stencilWriteMask => ctx.getParameter(ContextParameter.STENCIL_WRITEMASK.index);
  int get stencilBackWriteMask => ctx.getParameter(ContextParameter.STENCIL_BACK_WRITEMASK.index);
  set stencilMaks(int value) => ctx.stencilMask(value);

  int get clearStencil => ctx.getParameter(ContextParameter.STENCIL_CLEAR_VALUE.index);
  set clearStencil(int index){
    ctx.clearStencil(index) ;
  }

  //Blend
  //Todo : ? identique à get parameter ? BLEND
  bool get blend => isEnabled(EnableCapabilityType.BLEND);
  set blend (bool enabled) => _setEnabled(EnableCapabilityType.BLEND.index, enabled);

  void blendFunc(BlendFactorMode sourceFactor, BlendFactorMode destinationFactor){
    ctx.blendFunc(sourceFactor.index, destinationFactor.index);
  }
  void blendFuncSeparate(BlendFactorMode srcRGB, BlendFactorMode dstRGB, BlendFactorMode srcAlpha, BlendFactorMode dstAlpha){
    ctx.blendFuncSeparate(srcRGB.index, dstRGB.index, srcAlpha.index, dstAlpha.index);
  }
  void setBlendColor(num red, num green, num blue, num alpha){
    assert(0.0 <= red && red <= 1.0);
    assert(0.0 <= green && green <= 1.0);
    assert(0.0 <= blue && blue <= 1.0);
    assert(0.0 <= alpha && alpha <= 1.0);
    ctx.blendColor(red, green, blue, alpha);
  }
  // > BLEND_COLOR
  Float32List get blendColor => ctx.getParameter(ContextParameter.BLEND_COLOR.index);
  set blendColor(Float32List values){
    assert(values.length == 4);
    setBlendColor(values[0], values[1], values[2], values[3]);
  }
  // > BLEND_SRC_RGB, BLEND_DST_RGB, BLEND_SRC_ALPHA, BLEND_DST_ALPHA
  BlendFactorMode get blendSrcRGB => new BlendFactorMode(ctx.getParameter(ContextParameter.BLEND_SRC_RGB.index));
  BlendFactorMode get blendSrcAlpha => new BlendFactorMode(ctx.getParameter(ContextParameter.BLEND_SRC_ALPHA.index));
  BlendFactorMode get blendDstRGB => new BlendFactorMode(ctx.getParameter(ContextParameter.BLEND_DST_RGB.index));
  BlendFactorMode get blendDstAlpha => new BlendFactorMode(ctx.getParameter(ContextParameter.BLEND_DST_ALPHA.index));

  // > BLEND_EQUATION, BLEND_EQUATION_RGB, BLEND_EQUATION_ALPHA
  BlendFunctionMode get blendEquation => new BlendFunctionMode(ctx.getParameter(ContextParameter.BLEND_EQUATION.index));
  BlendFunctionMode get blendEquationRGB => new BlendFunctionMode(ctx.getParameter(ContextParameter.BLEND_EQUATION_RGB.index));
  BlendFunctionMode get blendEquationAlpha => new BlendFunctionMode(ctx.getParameter(ContextParameter.BLEND_EQUATION_ALPHA .index));
  set blendEquation(BlendFunctionMode mode) => ctx.blendEquation(mode.index);

  void blendEquationSeparate(BlendFunctionMode modeRGB, BlendFunctionMode modeAlpha){
    ctx.blendEquationSeparate(modeRGB.index, modeAlpha.index);
  }

  //Dither
  // > DITHER
  bool get dither => isEnabled(EnableCapabilityType.DITHER);
  set dither (bool enabled) => _setEnabled(EnableCapabilityType.DITHER.index, enabled);

  //EnableCapabilityType enabling
  void enable(EnableCapabilityType cap) {
    ctx.enable(cap.index);
  }
  void disable(EnableCapabilityType cap) {
    ctx.disable(cap.index);
  }

  void _setEnabled(EnableCapabilityType enableCapType, bool enabled){
    if(enabled){
      enable(enableCapType);
    } else {
      disable(enableCapType);
    }
  }

  bool isEnabled(EnableCapabilityType cap) {
    return ctx.isEnabled(cap.index);
  }

  //
  set clearColor(Vector4 color){
    ctx.clearColor(color.r, color.g, color.b, color.a);
  }

  // > COLOR_WRITEMASK [4]
  List<bool> get colorMask => ctx.getParameter(ContextParameter.COLOR_WRITEMASK.index);
  set colorMask(List<bool> mask){
      assert(mask.length == 4);
      ctx.colorMask(mask[0], mask[1], mask[2], mask[3]);
  }

  void clear(List<ClearBufferMask> masks) {
    //Todo : change with bitmask : RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT
    int bitmask = 0;
    for(ClearBufferMask mask in masks) {
      bitmask |= mask.index;
    }
    ctx.clear(bitmask);
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

  //data type ?
  void bufferSubData(BufferType bufferType,int offset, {dynamic data}) {
    assert(data != null);
    ctx.bufferSubData(bufferType.index, offset, data);
  }

  //Textures
  void bindTexture(TextureTarget target, WebGLTexture texture) {
    ctx.bindTexture(target.index, texture?.webGLTexture);
  }

  //RenderBuffer
  void bindRenderBuffer(RenderBufferTarget target, WebGLRenderBuffer renderBuffer) {
    ctx.bindRenderbuffer(target.index, renderBuffer?.webGLRenderBuffer);
  }

  //FrameBuffer
  void bindFrameBuffer(FrameBufferTarget target, WebGLFrameBuffer webGLframeBuffer) {
    ctx.bindFramebuffer(target.index, webGLframeBuffer.webGLFrameBuffer);
  }

  //Extensions
  List<String> get supportedExtensions => ctx.getSupportedExtensions();

  dynamic getExtension(String extensionName){
    return ctx.getExtension(extensionName);
  }

  // > MAX_VIEWPORT_DIMS
  Int32List get viewportDimensions => ctx.getParameter(ContextParameter.MAX_VIEWPORT_DIMS.index);

  // > VIEWPORT
  Rectangle get viewport {
    Int32List values = ctx.getParameter(ContextParameter.VIEWPORT.index);
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set viewport(Rectangle rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    ctx.viewport(rect.left, rect.top, rect.width, rect.height);
  }

  // > PACK_ALIGNMENT
  int get packAlignment => ctx.getParameter(ContextParameter.PACK_ALIGNMENT.index);
  void pixelStorei(PixelStorgeType storage, int value) => ctx.pixelStorei(storage.index, value);

  // DRAW
  void drawArrays(DrawMode mode, int firstVertexIndex, int vertexCount) {
    assert(firstVertexIndex >= 0 && vertexCount >= 0);
    ctx.drawArrays(mode.index, firstVertexIndex, vertexCount);
  }

  void drawElements(DrawMode mode, int count, ElementType type, int offset) {
    ctx.drawElements(mode.index, count, type.index, offset);
  }

  //Texture
  void texImage2DWithWidthAndHeight(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormatType internalFormat, int width, int height, int border, TextureInternalFormatType internalFormat2, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(internalFormat.index == internalFormat2.index);//in webgl1
    ctx.texImage2D(target.index, mipMapLevel, internalFormat.index, width, height, border, internalFormat2.index, texelDataType.index, pixels);
  }

  void texImage2D(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormatType internalFormat, TextureInternalFormatType internalFormat2, TexelDataType texelDataType, pixels) {
    assert(internalFormat.index == internalFormat2.index);//in webgl1
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    ctx.texImage2D(target.index, mipMapLevel, internalFormat.index, internalFormat2.index, texelDataType.index, pixels);
  }

  void texSubImage2DWithWidthAndHeight(TextureAttachmentTarget target, int mipMapLevel, int xOffset, int yOffset, int width, int height, TextureInternalFormatType internalFormat, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    ctx.texSubImage2D(target.index, mipMapLevel, xOffset, yOffset, width, height, internalFormat.index, texelDataType.index, pixels);
  }

  void texSubImage2D(TextureAttachmentTarget target, int mipMapLevel, int xOffset, int yOffset, TextureInternalFormatType internalFormat, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    ctx.texSubImage2D(target.index, mipMapLevel, xOffset, yOffset, internalFormat.index, texelDataType.index, pixels);
  }

  void copyTexImage2D(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormatType internalFormat,
      int x, int y, int width, int height, pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    assert(width >= 0);
    assert(height >= 0);
    ctx.copyTexImage2D(target.index, mipMapLevel, internalFormat.index, x, y, width, height, pixels);
  }

  ///copies pixels from the current WebGLFramebuffer into an existing 2D texture sub-image.
  void copyTexSubImage2D(TextureAttachmentTarget target, int mipMapLevel, int xOffset, int yOffset,
      int x, int y, int width, int height) {
    assert(width >= 0);
    assert(height >= 0);
    ctx.copyTexSubImage2D(target.index, mipMapLevel, xOffset, yOffset, x, y, width, height);
  }
  // > GENERATE_MIPMAP_HINT // Todo : return GLenum
  int get generateMipMapHint => ctx.getParameter(ContextParameter.GENERATE_MIPMAP_HINT.index);
  void hint(HintMode mode){
    ctx.hint(ContextParameter.GENERATE_MIPMAP_HINT.index, mode.index);
  }


  void readPixels(int left, int top, int width, int height, ReadPixelDataFormat format, ReadPixelDataType type, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    ctx.readPixels(left, top, width, height, format.index, type.index, pixels);
  }


  //Errors
  ErrorCode getError(){
    return new ErrorCode(ctx.getError());
  }



  ///avoid this method.
  ///blocks execution until all previously called commands are finished.
  void finish(){
    ctx.finish();
  }

  ///empties different buffer commands, causing all commands to be
  ///executed as quickly as possible.
  void flush(){
    ctx.flush();
  }
}
