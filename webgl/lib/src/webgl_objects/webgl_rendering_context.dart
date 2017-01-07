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

class ErrorType{
  final index;
  const ErrorType(this.index);

  static const ErrorType NO_ERROR = const ErrorType(WebGL.RenderingContext.NO_ERROR);
  static const ErrorType INVALID_ENUM = const ErrorType(WebGL.RenderingContext.INVALID_ENUM);
  static const ErrorType INVALID_VALUE = const ErrorType(WebGL.RenderingContext.INVALID_VALUE);
  static const ErrorType INVALID_OPERATION = const ErrorType(WebGL.RenderingContext.INVALID_OPERATION);
  static const ErrorType INVALID_FRAMEBUFFER_OPERATION = const ErrorType(WebGL.RenderingContext.INVALID_FRAMEBUFFER_OPERATION);
  static const ErrorType OUT_OF_MEMORY = const ErrorType(WebGL.RenderingContext.OUT_OF_MEMORY);
  static const ErrorType CONTEXT_LOST_WEBGL = const ErrorType(WebGL.RenderingContext.CONTEXT_LOST_WEBGL);
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

  bool get isContextLost => ctx.isContextLost();

  set frontFace(FaceMode mode){
    ctx.frontFace(mode.index);
  }

  //CullFace
  bool get cullFace => isEnabled(EnableCapabilityType.CULL_FACE.index);
  set cullFace(bool enable){
    _setEnabled(EnableCapabilityType.CULL_FACE, enable);
  }

  set cullFaceMode(FacingType mode){
    ctx.cullFace(mode.index);
  }

  //Depth
  bool get depthTest => ctx.isEnabled(EnableCapabilityType.DEPTH_TEST.index);
  set depthTest(bool enable){
    _setEnabled(EnableCapabilityType.DEPTH_TEST, enable);
  }

  bool get depthMask => ctx.getParameter(ContextParameter.DEPTH_WRITEMASK.index);
  set depthMask(bool enable){
      ctx.depthMask(enable);
  }

  ComparisonFunction get depthFunc => new ComparisonFunction(ctx.getParameter(ContextParameter.DEPTH_FUNC.index));
  set depthFunc(ComparisonFunction depthComparisionFunction){
    ctx.depthFunc(depthComparisionFunction.index);
  }

  void depthRange(num zNear, num zFar) {
    ctx.depthRange(zNear, zFar);
  }

  num get clearDepth => ctx.getParameter(ContextParameter.DEPTH_CLEAR_VALUE.index);
  set clearDepth(num depthValue){
    assert(0.0 <= depthValue && depthValue <= 1.0);
    ctx.clearDepth(depthValue);
  }

  //Scissor
  Rectangle get scissor {
    Int32List values = getParameter(ContextParameter.SCISSOR_BOX);
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set scissor(Rectangle rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    ctx.scissor(rect.left, rect.top, rect.width, rect.height);
  }

  bool get scissorTest => isEnabled(EnableCapabilityType.SCISSOR_TEST);
  set scissorTest(bool enabled) => _setEnabled(EnableCapabilityType.SCISSOR_TEST, enabled);

  //lineWidth
  num get lineWidth => ctx.getParameter(ContextParameter.LINE_WIDTH.index);
  set lineWidth(num width){
    ctx.lineWidth(width);
  }
  Float32List get lineWidthRange => ctx.getParameter(ContextParameter.ALIASED_LINE_WIDTH_RANGE.index);

  //Polygon offset
  bool get polygonOffset => ctx.isEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL.index);
  set polygonOffset(bool enabled) =>_setEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL, enabled);

  num get polygonOffsetFactor => ctx.getParameter(ContextParameter.POLYGON_OFFSET_FACTOR.index);
  num get polygonOffsetUnits => ctx.getParameter(ContextParameter.POLYGON_OFFSET_UNITS.index);
  void setPolygonOffest(num factor, num units){
    ctx.polygonOffset(factor, units);
  }

  //MultiSampleCoverage
  bool get sampleCovarage => isEnabled(EnableCapabilityType.SAMPLE_COVERAGE);
  set sampleCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_COVERAGE, enabled);

  bool get sampleAlphaToCoverage => isEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE);
  set sampleAlphaToCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE, enabled);

  num get sampleCoverageValue => ctx.getParameter(ContextParameter.SAMPLE_COVERAGE_VALUE.index);
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
  int get stencilBits => ctx.getParameter(ContextParameter.STENCIL_BITS.index);
  set stencilMaks(int value) => ctx.stencilMask(value);

  int get clearStencil => ctx.getParameter(ContextParameter.STENCIL_CLEAR_VALUE.index);
  set clearStencil(int index){
    ctx.clearStencil(index) ;
  }

  //Blend
  bool get blend => isEnabled(EnableCapabilityType.BLEND);
  set blend (bool enabled) => _setEnabled(EnableCapabilityType.BLEND.index, enabled);

  void blendFunc(BlendFactorMode sourceFactor, BlendFactorMode destinationFactor){
    ctx.blendFunc(sourceFactor.index, destinationFactor.index);
  }
  void blendFuncSeparate(BlendFactorMode srcRGB, BlendFactorMode dstRGB, BlendFactorMode srcAlpha, BlendFactorMode dstAlpha){
    ctx.blendFuncSeparate(srcRGB.index, dstRGB.index, srcAlpha.index, dstAlpha.index);
  }
  void blendEquation(BlendFunctionMode mode){
    ctx.blendEquation(mode.index);
  }
  void blendEquationSeparate(BlendFunctionMode modeRGB, BlendFunctionMode modeAlpha){
    ctx.blendEquationSeparate(modeRGB.index, modeAlpha.index);
  }
  void blendColor(num red, num green, num blue, num alpha){
    assert(0.0 <= red && red <= 1.0);
    assert(0.0 <= green && green <= 1.0);
    assert(0.0 <= blue && blue <= 1.0);
    assert(0.0 <= alpha && alpha <= 1.0);
    ctx.blendColor(red, green, blue, alpha);
  }
  Float32List getBlendColor(){
    return ctx.getParameter(ContextParameter.BLEND_COLOR.index);
  }

  //Dither
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

  void readPixels(int left, int top, int width, int height, ReadPixelDataFormat format, ReadPixelDataType type, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    ctx.readPixels(left, top, width, height, format.index, type.index, pixels);
  }


  ErrorType getError(){
    return new ErrorType(ctx.getError());
  }

  void hint(HintMode mode){
    ctx.hint(ContextParameter.GENERATE_MIPMAP_HINT.index, mode.index);
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
