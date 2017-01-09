import 'dart:mirrors';
import 'dart:web_gl' as WebGL;

abstract class WebGLEnum<T> {

  final int _index;
  final String _name;

  const WebGLEnum(this._index, this._name);

  int get index => _index;
  String get name => _name;

  @override
  String toString(){
    return '$_name : $_index';
  }

  static Map<Type, List<WebGLEnum>> _typesMap = new Map();

  static WebGLEnum _findTypeByIndex(Type GLEnum, int enumIndex) {
    if(_typesMap[GLEnum] == null) {
      List<WebGLEnum> _types = new List();
      ClassMirror classMirror = reflectClass(GLEnum);
      List<MethodMirror> decls =
      classMirror.staticMembers.values.where((e) => e.isGetter).toList();

      decls.forEach(
          (decl) =>
          _types.add(classMirror
              .getField(decl.simpleName)
              .reflectee));

      _typesMap[GLEnum] = _types;
    }
    return _typesMap[GLEnum].firstWhere((WebGLEnum e) => e.runtimeType == GLEnum && e.index == enumIndex, orElse: () => null);
  }

}

//Todo : add extensions


//WebGLRenderingContext


class EnableCapabilityType extends WebGLEnum{

  const EnableCapabilityType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(EnableCapabilityType, index);

  static const EnableCapabilityType BLEND = const EnableCapabilityType(WebGL.RenderingContext.BLEND, 'BLEND');
  static const EnableCapabilityType CULL_FACE = const EnableCapabilityType(WebGL.RenderingContext.CULL_FACE, 'CULL_FACE');
  static const EnableCapabilityType DEPTH_TEST = const EnableCapabilityType(WebGL.RenderingContext.DEPTH_TEST, 'DEPTH_TEST');
  static const EnableCapabilityType DITHER = const EnableCapabilityType(WebGL.RenderingContext.DITHER, 'DITHER'); //Todo : add enabling ?
  static const EnableCapabilityType POLYGON_OFFSET_FILL = const EnableCapabilityType(WebGL.RenderingContext.POLYGON_OFFSET_FILL, 'POLYGON_OFFSET_FILL');
  static const EnableCapabilityType SAMPLE_ALPHA_TO_COVERAGE = const EnableCapabilityType(WebGL.RenderingContext.SAMPLE_ALPHA_TO_COVERAGE, 'SAMPLE_ALPHA_TO_COVERAGE');
  static const EnableCapabilityType SAMPLE_COVERAGE = const EnableCapabilityType(WebGL.RenderingContext.SAMPLE_COVERAGE, 'SAMPLE_COVERAGE');
  static const EnableCapabilityType SCISSOR_TEST = const EnableCapabilityType(WebGL.RenderingContext.SCISSOR_TEST, 'SCISSOR_TEST');
  static const EnableCapabilityType STENCIL_TEST = const EnableCapabilityType(WebGL.RenderingContext.STENCIL_TEST, 'STENCIL_TEST');
}

class FacingType extends WebGLEnum{

  const FacingType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FacingType, index);

  static const FacingType FRONT = const FacingType(WebGL.RenderingContext.FRONT, 'FRONT');
  static const FacingType BACK = const FacingType(WebGL.RenderingContext.BACK, 'BACK');
  static const FacingType FRONT_AND_BACK = const FacingType(WebGL.RenderingContext.FRONT_AND_BACK, 'FRONT_AND_BACK');
}

class ClearBufferMask extends WebGLEnum{

  const ClearBufferMask(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ClearBufferMask, index);

  static const ClearBufferMask DEPTH_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.DEPTH_BUFFER_BIT, 'DEPTH_BUFFER_BIT');
  static const ClearBufferMask STENCIL_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.STENCIL_BUFFER_BIT, 'STENCIL_BUFFER_BIT');
  static const ClearBufferMask COLOR_BUFFER_BIT = const ClearBufferMask(WebGL.RenderingContext.COLOR_BUFFER_BIT, 'COLOR_BUFFER_BIT');
}

class FrontFaceDirection extends WebGLEnum{

  const FrontFaceDirection(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FrontFaceDirection, index);

  static const FrontFaceDirection CW = const FrontFaceDirection(WebGL.RenderingContext.CW, 'CW');
  static const FrontFaceDirection CCW = const FrontFaceDirection(WebGL.RenderingContext.CCW, 'CCW');
}

class PixelStorgeType extends WebGLEnum{

  const PixelStorgeType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(PixelStorgeType, index);

  static const PixelStorgeType PACK_ALIGNMENT = const PixelStorgeType(WebGL.RenderingContext.PACK_ALIGNMENT, 'PACK_ALIGNMENT');
  static const PixelStorgeType UNPACK_ALIGNMENT = const PixelStorgeType(WebGL.RenderingContext.UNPACK_ALIGNMENT, 'UNPACK_ALIGNMENT');
  static const PixelStorgeType UNPACK_FLIP_Y_WEBGL = const PixelStorgeType(WebGL.RenderingContext.UNPACK_FLIP_Y_WEBGL, 'UNPACK_FLIP_Y_WEBGL');
  static const PixelStorgeType UNPACK_PREMULTIPLY_ALPHA_WEBGL = const PixelStorgeType(WebGL.RenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 'UNPACK_PREMULTIPLY_ALPHA_WEBGL');
  static const PixelStorgeType UNPACK_COLORSPACE_CONVERSION_WEBGL = const PixelStorgeType(WebGL.RenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL, 'UNPACK_COLORSPACE_CONVERSION_WEBGL');
}

class DrawMode extends WebGLEnum{

  const DrawMode(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(DrawMode, index);

  static const DrawMode POINTS = const DrawMode(WebGL.RenderingContext.POINTS, 'POINTS');
  static const DrawMode LINE_STRIP = const DrawMode(WebGL.RenderingContext.LINE_STRIP, 'LINE_STRIP');
  static const DrawMode LINE_LOOP = const DrawMode(WebGL.RenderingContext.LINE_LOOP, 'LINE_LOOP');
  static const DrawMode LINES = const DrawMode(WebGL.RenderingContext.LINES, 'LINES');
  static const DrawMode TRIANGLE_STRIP = const DrawMode(WebGL.RenderingContext.TRIANGLE_STRIP, 'TRIANGLE_STRIP');
  static const DrawMode TRIANGLE_FAN = const DrawMode(WebGL.RenderingContext.TRIANGLE_FAN, 'TRIANGLE_FAN');
  static const DrawMode TRIANGLES = const DrawMode(WebGL.RenderingContext.TRIANGLES, 'TRIANGLES');
}

class BufferElementType extends WebGLEnum{

  const BufferElementType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(BufferElementType, index);

  static const BufferElementType UNSIGNED_BYTE = const BufferElementType(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const BufferElementType UNSIGNED_SHORT = const BufferElementType(WebGL.RenderingContext.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
}

class ReadPixelDataFormat extends WebGLEnum{

  const ReadPixelDataFormat(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ReadPixelDataFormat, index);

  static const ReadPixelDataFormat ALPHA = const ReadPixelDataFormat(WebGL.RenderingContext.ALPHA, 'ALPHA');
  static const ReadPixelDataFormat RGB = const ReadPixelDataFormat(WebGL.RenderingContext.RGB, 'RGB');
  static const ReadPixelDataFormat RGBA = const ReadPixelDataFormat(WebGL.RenderingContext.RGBA, 'RGBA');
}

class ReadPixelDataType extends WebGLEnum{

  const ReadPixelDataType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ReadPixelDataType, index);

  static const ReadPixelDataType UNSIGNED_BYTE = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const ReadPixelDataType UNSIGNED_SHORT_5_6_5 = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5, 'UNSIGNED_SHORT_5_6_5');
  static const ReadPixelDataType UNSIGNED_SHORT_4_4_4_4 = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4, 'UNSIGNED_SHORT_4_4_4_4');
  static const ReadPixelDataType UNSIGNED_SHORT_5_5_5_1 = const ReadPixelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1, 'UNSIGNED_SHORT_5_5_5_1');
  static const ReadPixelDataType FLOAT = const ReadPixelDataType(WebGL.RenderingContext.FLOAT, 'FLOAT');
}

class ComparisonFunction extends WebGLEnum{

  const ComparisonFunction(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ComparisonFunction, index);

  static const ComparisonFunction NEVER = const ComparisonFunction(WebGL.RenderingContext.NEVER, 'NEVER');
  static const ComparisonFunction LESS = const ComparisonFunction(WebGL.RenderingContext.LESS, 'LESS');
  static const ComparisonFunction EQUAL = const ComparisonFunction(WebGL.RenderingContext.EQUAL, 'EQUAL');
  static const ComparisonFunction LEQUAL = const ComparisonFunction(WebGL.RenderingContext.LEQUAL, 'LEQUAL');
  static const ComparisonFunction GREATER = const ComparisonFunction(WebGL.RenderingContext.GREATER, 'GREATER');
  static const ComparisonFunction NOTEQUAL = const ComparisonFunction(WebGL.RenderingContext.NOTEQUAL, 'NOTEQUAL');
  static const ComparisonFunction GEQUAL = const ComparisonFunction(WebGL.RenderingContext.GEQUAL, 'GEQUAL');
  static const ComparisonFunction ALWAYS = const ComparisonFunction(WebGL.RenderingContext.ALWAYS, 'ALWAYS');
}

class ErrorCode extends WebGLEnum{

  const ErrorCode(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ErrorCode, index);

  static const ErrorCode NO_ERROR = const ErrorCode(WebGL.RenderingContext.NO_ERROR, 'NO_ERROR');
  static const ErrorCode INVALID_ENUM = const ErrorCode(WebGL.RenderingContext.INVALID_ENUM, 'INVALID_ENUM');
  static const ErrorCode INVALID_VALUE = const ErrorCode(WebGL.RenderingContext.INVALID_VALUE, 'INVALID_VALUE');
  static const ErrorCode INVALID_OPERATION = const ErrorCode(WebGL.RenderingContext.INVALID_OPERATION, 'INVALID_OPERATION');
  static const ErrorCode INVALID_FRAMEBUFFER_OPERATION = const ErrorCode(WebGL.RenderingContext.INVALID_FRAMEBUFFER_OPERATION, 'INVALID_FRAMEBUFFER_OPERATION');
  static const ErrorCode OUT_OF_MEMORY = const ErrorCode(WebGL.RenderingContext.OUT_OF_MEMORY, 'OUT_OF_MEMORY');
  static const ErrorCode CONTEXT_LOST_WEBGL = const ErrorCode(WebGL.RenderingContext.CONTEXT_LOST_WEBGL, 'CONTEXT_LOST_WEBGL');
}

class HintMode extends WebGLEnum{

  const HintMode(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(HintMode, index);

  static const HintMode FASTEST = const HintMode(WebGL.RenderingContext.FASTEST, 'FASTEST');
  static const HintMode NICEST = const HintMode(WebGL.RenderingContext.NICEST, 'NICEST');
  static const HintMode DONT_CARE = const HintMode(WebGL.RenderingContext.DONT_CARE, 'DONT_CARE');
}

class StencilOpMode extends WebGLEnum{

  const StencilOpMode(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(StencilOpMode, index);

  static const StencilOpMode ZERO = const StencilOpMode(WebGL.RenderingContext.ZERO, 'ZERO');
  static const StencilOpMode KEEP = const StencilOpMode(WebGL.RenderingContext.KEEP, 'KEEP');
  static const StencilOpMode REPLACE = const StencilOpMode(WebGL.RenderingContext.REPLACE, 'REPLACE');
  static const StencilOpMode INVERT = const StencilOpMode(WebGL.RenderingContext.INVERT, 'INVERT');
  static const StencilOpMode INCR = const StencilOpMode(WebGL.RenderingContext.INCR, 'INCR');
  static const StencilOpMode INCR_WRAP = const StencilOpMode(WebGL.RenderingContext.INCR_WRAP, 'INCR_WRAP');
  static const StencilOpMode DECR = const StencilOpMode(WebGL.RenderingContext.DECR, 'DECR');
  static const StencilOpMode DECR_WRAP = const StencilOpMode(WebGL.RenderingContext.DECR_WRAP, 'DECR_WRAP');
}

class BlendFactorMode extends WebGLEnum{

  const BlendFactorMode(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(BlendFactorMode, index);

  static const BlendFactorMode ZERO = const BlendFactorMode(WebGL.RenderingContext.ZERO, 'ZERO');
  static const BlendFactorMode ONE = const BlendFactorMode(WebGL.RenderingContext.ONE, 'ONE');
  static const BlendFactorMode SRC_COLOR = const BlendFactorMode(WebGL.RenderingContext.SRC_COLOR, 'SRC_COLOR');
  static const BlendFactorMode SRC_ALPHA = const BlendFactorMode(WebGL.RenderingContext.SRC_ALPHA, 'SRC_ALPHA');
  static const BlendFactorMode SRC_ALPHA_SATURATE = const BlendFactorMode(WebGL.RenderingContext.SRC_ALPHA_SATURATE, 'SRC_ALPHA_SATURATE');
  static const BlendFactorMode DST_COLOR = const BlendFactorMode(WebGL.RenderingContext.DST_COLOR, 'DST_COLOR');
  static const BlendFactorMode DST_ALPHA = const BlendFactorMode(WebGL.RenderingContext.DST_ALPHA, 'DST_ALPHA');
  static const BlendFactorMode CONSTANT_COLOR = const BlendFactorMode(WebGL.RenderingContext.CONSTANT_COLOR, 'CONSTANT_COLOR');
  static const BlendFactorMode CONSTANT_ALPHA = const BlendFactorMode(WebGL.RenderingContext.CONSTANT_ALPHA, 'CONSTANT_ALPHA');
  static const BlendFactorMode ONE_MINUS_SRC_COLOR = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_SRC_COLOR, 'ONE_MINUS_SRC_COLOR');
  static const BlendFactorMode ONE_MINUS_SRC_ALPHA = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_SRC_ALPHA, 'ONE_MINUS_SRC_ALPHA');
  static const BlendFactorMode ONE_MINUS_DST_COLOR = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_DST_COLOR, 'ONE_MINUS_DST_COLOR');
  static const BlendFactorMode ONE_MINUS_DST_ALPHA = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_DST_ALPHA, 'ONE_MINUS_DST_ALPHA');
  static const BlendFactorMode ONE_MINUS_CONSTANT_COLOR = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_CONSTANT_COLOR, 'ONE_MINUS_CONSTANT_COLOR');
  static const BlendFactorMode ONE_MINUS_CONSTANT_ALPHA = const BlendFactorMode(WebGL.RenderingContext.ONE_MINUS_CONSTANT_ALPHA, 'ONE_MINUS_CONSTANT_ALPHA');
}

class BlendFunctionMode extends WebGLEnum{

  const BlendFunctionMode(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(BlendFunctionMode, index);

  static const BlendFunctionMode FUNC_ADD = const BlendFunctionMode(WebGL.RenderingContext.FUNC_ADD, 'FUNC_ADD');
  static const BlendFunctionMode FUNC_SUBTRACT = const BlendFunctionMode(WebGL.RenderingContext.FUNC_SUBTRACT, 'FUNC_SUBTRACT');
  static const BlendFunctionMode FUNC_REVERSE_SUBTRACT = const BlendFunctionMode(WebGL.RenderingContext.FUNC_REVERSE_SUBTRACT, 'FUNC_REVERSE_SUBTRACT');
}

class ContextParameter extends WebGLEnum{

  const ContextParameter(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ContextParameter, index);

  static const ContextParameter ACTIVE_TEXTURE = const ContextParameter(WebGL.RenderingContext.ACTIVE_TEXTURE, 'ACTIVE_TEXTURE');
  static const ContextParameter ALIASED_LINE_WIDTH_RANGE = const ContextParameter(WebGL.RenderingContext.ALIASED_LINE_WIDTH_RANGE, 'ALIASED_LINE_WIDTH_RANGE');
  static const ContextParameter ALIASED_POINT_SIZE_RANGE = const ContextParameter(WebGL.RenderingContext.ALIASED_POINT_SIZE_RANGE, 'ALIASED_POINT_SIZE_RANGE');
  static const ContextParameter ALPHA_BITS = const ContextParameter(WebGL.RenderingContext.ALPHA_BITS, 'ALPHA_BITS');
  static const ContextParameter ARRAY_BUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.ARRAY_BUFFER_BINDING, 'ARRAY_BUFFER_BINDING');
  static const ContextParameter BLEND = const ContextParameter(WebGL.RenderingContext.BLEND, 'BLEND');
  static const ContextParameter BLEND_COLOR = const ContextParameter(WebGL.RenderingContext.BLEND_COLOR, 'BLEND_COLOR');
  static const ContextParameter BLEND_DST_ALPHA = const ContextParameter(WebGL.RenderingContext.BLEND_DST_ALPHA, 'BLEND_DST_ALPHA');
  static const ContextParameter BLEND_DST_RGB = const ContextParameter(WebGL.RenderingContext.BLEND_DST_RGB, 'BLEND_DST_RGB');
  static const ContextParameter BLEND_EQUATION = const ContextParameter(WebGL.RenderingContext.BLEND_EQUATION, 'BLEND_EQUATION');
  static const ContextParameter BLEND_EQUATION_ALPHA = const ContextParameter(WebGL.RenderingContext.BLEND_EQUATION_ALPHA, 'BLEND_EQUATION_ALPHA');
  static const ContextParameter BLEND_EQUATION_RGB = const ContextParameter(WebGL.RenderingContext.BLEND_EQUATION_RGB, 'BLEND_EQUATION_RGB');
  static const ContextParameter BLEND_SRC_ALPHA = const ContextParameter(WebGL.RenderingContext.BLEND_SRC_ALPHA, 'BLEND_SRC_ALPHA');
  static const ContextParameter BLEND_SRC_RGB = const ContextParameter(WebGL.RenderingContext.BLEND_SRC_RGB, 'BLEND_SRC_RGB');
  static const ContextParameter BLUE_BITS = const ContextParameter(WebGL.RenderingContext.BLUE_BITS, 'BLUE_BITS');
  static const ContextParameter COLOR_CLEAR_VALUE = const ContextParameter(WebGL.RenderingContext.COLOR_CLEAR_VALUE, 'COLOR_CLEAR_VALUE');
  static const ContextParameter COLOR_WRITEMASK = const ContextParameter(WebGL.RenderingContext.COLOR_WRITEMASK, 'COLOR_WRITEMASK');
  static const ContextParameter COMPRESSED_TEXTURE_FORMATS = const ContextParameter(WebGL.RenderingContext.COMPRESSED_TEXTURE_FORMATS, 'COMPRESSED_TEXTURE_FORMATS');
  static const ContextParameter CULL_FACE_MODE = const ContextParameter(WebGL.RenderingContext.CULL_FACE_MODE, 'CULL_FACE_MODE');
  static const ContextParameter CURRENT_PROGRAM = const ContextParameter(WebGL.RenderingContext.CURRENT_PROGRAM, 'CURRENT_PROGRAM');
  static const ContextParameter DEPTH_BITS = const ContextParameter(WebGL.RenderingContext.DEPTH_BITS, 'DEPTH_BITS');
  static const ContextParameter DEPTH_CLEAR_VALUE = const ContextParameter(WebGL.RenderingContext.DEPTH_CLEAR_VALUE, 'DEPTH_CLEAR_VALUE');
  static const ContextParameter DEPTH_FUNC = const ContextParameter(WebGL.RenderingContext.DEPTH_FUNC, 'DEPTH_FUNC');
  static const ContextParameter DEPTH_RANGE = const ContextParameter(WebGL.RenderingContext.DEPTH_RANGE, 'DEPTH_RANGE');
  static const ContextParameter DEPTH_TEST = const ContextParameter(WebGL.RenderingContext.DEPTH_TEST, 'DEPTH_TEST');
  static const ContextParameter DEPTH_WRITEMASK = const ContextParameter(WebGL.RenderingContext.DEPTH_WRITEMASK, 'DEPTH_WRITEMASK');
  static const ContextParameter DITHER = const ContextParameter(WebGL.RenderingContext.DITHER, 'DITHER');
  static const ContextParameter ELEMENT_ARRAY_BUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER_BINDING, 'ELEMENT_ARRAY_BUFFER_BINDING');
  static const ContextParameter FRAMEBUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.FRAMEBUFFER_BINDING, 'FRAMEBUFFER_BINDING');
  static const ContextParameter FRONT_FACE = const ContextParameter(WebGL.RenderingContext.FRONT_FACE, 'FRONT_FACE');
  static const ContextParameter GENERATE_MIPMAP_HINT = const ContextParameter(WebGL.RenderingContext.GENERATE_MIPMAP_HINT, 'GENERATE_MIPMAP_HINT');
  static const ContextParameter GREEN_BITS = const ContextParameter(WebGL.RenderingContext.GREEN_BITS, 'GREEN_BITS');
  static const ContextParameter IMPLEMENTATION_COLOR_READ_FORMAT = const ContextParameter(WebGL.RenderingContext.IMPLEMENTATION_COLOR_READ_FORMAT, 'IMPLEMENTATION_COLOR_READ_FORMAT');
  static const ContextParameter IMPLEMENTATION_COLOR_READ_TYPE = const ContextParameter(WebGL.RenderingContext.IMPLEMENTATION_COLOR_READ_TYPE, 'IMPLEMENTATION_COLOR_READ_TYPE');
  static const ContextParameter LINE_WIDTH = const ContextParameter(WebGL.RenderingContext.LINE_WIDTH, 'LINE_WIDTH');
  static const ContextParameter MAX_COMBINED_TEXTURE_IMAGE_UNITS = const ContextParameter(WebGL.RenderingContext.MAX_COMBINED_TEXTURE_IMAGE_UNITS, 'MAX_COMBINED_TEXTURE_IMAGE_UNITS');
  static const ContextParameter MAX_CUBE_MAP_TEXTURE_SIZE = const ContextParameter(WebGL.RenderingContext.MAX_CUBE_MAP_TEXTURE_SIZE, 'MAX_CUBE_MAP_TEXTURE_SIZE');
  static const ContextParameter MAX_FRAGMENT_UNIFORM_VECTORS = const ContextParameter(WebGL.RenderingContext.MAX_FRAGMENT_UNIFORM_VECTORS, 'MAX_FRAGMENT_UNIFORM_VECTORS');
  static const ContextParameter MAX_RENDERBUFFER_SIZE = const ContextParameter(WebGL.RenderingContext.MAX_RENDERBUFFER_SIZE, 'MAX_RENDERBUFFER_SIZE');
  static const ContextParameter MAX_TEXTURE_IMAGE_UNITS = const ContextParameter(WebGL.RenderingContext.MAX_TEXTURE_IMAGE_UNITS, 'MAX_TEXTURE_IMAGE_UNITS');
  static const ContextParameter MAX_TEXTURE_SIZE = const ContextParameter(WebGL.RenderingContext.MAX_TEXTURE_SIZE, 'MAX_TEXTURE_SIZE');
  static const ContextParameter MAX_VARYING_VECTORS = const ContextParameter(WebGL.RenderingContext.MAX_VARYING_VECTORS, 'MAX_VARYING_VECTORS');
  static const ContextParameter MAX_VERTEX_ATTRIBS = const ContextParameter(WebGL.RenderingContext.MAX_VERTEX_ATTRIBS, 'MAX_VERTEX_ATTRIBS');
  static const ContextParameter MAX_VERTEX_TEXTURE_IMAGE_UNITS = const ContextParameter(WebGL.RenderingContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS, 'MAX_VERTEX_TEXTURE_IMAGE_UNITS');
  static const ContextParameter MAX_VERTEX_UNIFORM_VECTORS = const ContextParameter(WebGL.RenderingContext.MAX_VERTEX_UNIFORM_VECTORS, 'MAX_VERTEX_UNIFORM_VECTORS');
  static const ContextParameter MAX_VIEWPORT_DIMS = const ContextParameter(WebGL.RenderingContext.MAX_VIEWPORT_DIMS, 'MAX_VIEWPORT_DIMS');
  static const ContextParameter PACK_ALIGNMENT = const ContextParameter(WebGL.RenderingContext.PACK_ALIGNMENT, 'PACK_ALIGNMENT');
  static const ContextParameter POLYGON_OFFSET_FACTOR = const ContextParameter(WebGL.RenderingContext.POLYGON_OFFSET_FACTOR, 'POLYGON_OFFSET_FACTOR');
  static const ContextParameter POLYGON_OFFSET_FILL = const ContextParameter(WebGL.RenderingContext.POLYGON_OFFSET_FILL, 'POLYGON_OFFSET_FILL');
  static const ContextParameter POLYGON_OFFSET_UNITS = const ContextParameter(WebGL.RenderingContext.POLYGON_OFFSET_UNITS, 'POLYGON_OFFSET_UNITS');
  static const ContextParameter RED_BITS = const ContextParameter(WebGL.RenderingContext.RED_BITS, 'RED_BITS');
  static const ContextParameter RENDERBUFFER_BINDING = const ContextParameter(WebGL.RenderingContext.RENDERBUFFER_BINDING, 'RENDERBUFFER_BINDING');
  static const ContextParameter RENDERER = const ContextParameter(WebGL.RenderingContext.RENDERER, 'RENDERER');
  static const ContextParameter SAMPLE_BUFFERS = const ContextParameter(WebGL.RenderingContext.SAMPLE_BUFFERS, 'SAMPLE_BUFFERS');
  static const ContextParameter SAMPLE_COVERAGE_INVERT = const ContextParameter(WebGL.RenderingContext.SAMPLE_COVERAGE_INVERT, 'SAMPLE_COVERAGE_INVERT');
  static const ContextParameter SAMPLE_COVERAGE_VALUE = const ContextParameter(WebGL.RenderingContext.SAMPLE_COVERAGE_VALUE, 'SAMPLE_COVERAGE_VALUE');
  static const ContextParameter SAMPLES = const ContextParameter(WebGL.RenderingContext.SAMPLES, 'SAMPLES');
  static const ContextParameter SCISSOR_BOX = const ContextParameter(WebGL.RenderingContext.SCISSOR_BOX, 'SCISSOR_BOX');
  static const ContextParameter SCISSOR_TEST = const ContextParameter(WebGL.RenderingContext.SCISSOR_TEST, 'SCISSOR_TEST');
  static const ContextParameter SHADING_LANGUAGE_VERSION = const ContextParameter(WebGL.RenderingContext.SHADING_LANGUAGE_VERSION, 'SHADING_LANGUAGE_VERSION');
  static const ContextParameter STENCIL_BACK_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_FAIL, 'STENCIL_BACK_FAIL');
  static const ContextParameter STENCIL_BACK_FUNC = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_FUNC, 'STENCIL_BACK_FUNC');
  static const ContextParameter STENCIL_BACK_PASS_DEPTH_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_PASS_DEPTH_FAIL, 'STENCIL_BACK_PASS_DEPTH_FAIL');
  static const ContextParameter STENCIL_BACK_PASS_DEPTH_PASS = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_PASS_DEPTH_PASS, 'STENCIL_BACK_PASS_DEPTH_PASS');
  static const ContextParameter STENCIL_BACK_REF = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_REF, 'STENCIL_BACK_REF');
  static const ContextParameter STENCIL_BACK_VALUE_MASK = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_VALUE_MASK, 'STENCIL_BACK_VALUE_MASK');
  static const ContextParameter STENCIL_BACK_WRITEMASK = const ContextParameter(WebGL.RenderingContext.STENCIL_BACK_WRITEMASK, 'STENCIL_BACK_WRITEMASK');
  static const ContextParameter STENCIL_BITS = const ContextParameter(WebGL.RenderingContext.STENCIL_BITS, 'STENCIL_BITS');
  static const ContextParameter STENCIL_CLEAR_VALUE = const ContextParameter(WebGL.RenderingContext.STENCIL_CLEAR_VALUE, 'STENCIL_CLEAR_VALUE');
  static const ContextParameter STENCIL_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_FAIL, 'STENCIL_FAIL');
  static const ContextParameter STENCIL_FUNC = const ContextParameter(WebGL.RenderingContext.STENCIL_FUNC, 'STENCIL_FUNC');
  static const ContextParameter STENCIL_PASS_DEPTH_FAIL = const ContextParameter(WebGL.RenderingContext.STENCIL_PASS_DEPTH_FAIL, 'STENCIL_PASS_DEPTH_FAIL');
  static const ContextParameter STENCIL_PASS_DEPTH_PASS = const ContextParameter(WebGL.RenderingContext.STENCIL_PASS_DEPTH_PASS, 'STENCIL_PASS_DEPTH_PASS');
  static const ContextParameter STENCIL_REF = const ContextParameter(WebGL.RenderingContext.STENCIL_REF, 'STENCIL_REF');
  static const ContextParameter STENCIL_TEST = const ContextParameter(WebGL.RenderingContext.STENCIL_TEST, 'STENCIL_TEST');
  static const ContextParameter STENCIL_VALUE_MASK = const ContextParameter(WebGL.RenderingContext.STENCIL_VALUE_MASK, 'STENCIL_VALUE_MASK');
  static const ContextParameter STENCIL_WRITEMASK = const ContextParameter(WebGL.RenderingContext.STENCIL_WRITEMASK, 'STENCIL_WRITEMASK');
  static const ContextParameter SUBPIXEL_BITS = const ContextParameter(WebGL.RenderingContext.SUBPIXEL_BITS, 'SUBPIXEL_BITS');
  static const ContextParameter TEXTURE_BINDING_2D = const ContextParameter(WebGL.RenderingContext.TEXTURE_BINDING_2D, 'TEXTURE_BINDING_2D');
  static const ContextParameter TEXTURE_BINDING_CUBE_MAP = const ContextParameter(WebGL.RenderingContext.TEXTURE_BINDING_CUBE_MAP, 'TEXTURE_BINDING_CUBE_MAP');
  static const ContextParameter UNPACK_ALIGNMENT = const ContextParameter(WebGL.RenderingContext.UNPACK_ALIGNMENT, 'UNPACK_ALIGNMENT');
  static const ContextParameter UNPACK_COLORSPACE_CONVERSION_WEBGL = const ContextParameter(WebGL.RenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL, 'UNPACK_COLORSPACE_CONVERSION_WEBGL');
  static const ContextParameter UNPACK_FLIP_Y_WEBGL = const ContextParameter(WebGL.RenderingContext.UNPACK_FLIP_Y_WEBGL, 'UNPACK_FLIP_Y_WEBGL');
  static const ContextParameter UNPACK_PREMULTIPLY_ALPHA_WEBGL = const ContextParameter(WebGL.RenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 'UNPACK_PREMULTIPLY_ALPHA_WEBGL');
  static const ContextParameter VENDOR = const ContextParameter(WebGL.RenderingContext.VENDOR, 'VENDOR');
  static const ContextParameter VERSION = const ContextParameter(WebGL.RenderingContext.VERSION, 'VERSION');
  static const ContextParameter VIEWPORT = const ContextParameter(WebGL.RenderingContext.VIEWPORT, 'VIEWPORT');
}


//WebGLRenderBuffers


class RenderBufferParameters extends WebGLEnum{

  const RenderBufferParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(RenderBufferParameters, index);

  static const RenderBufferParameters RENDERBUFFER_WIDTH = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_WIDTH, 'RENDERBUFFER_WIDTH');
  static const RenderBufferParameters RENDERBUFFER_HEIGHT = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_HEIGHT,'RENDERBUFFER_HEIGHT');
  static const RenderBufferParameters RENDERBUFFER_INTERNAL_FORMAT = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_INTERNAL_FORMAT,'RENDERBUFFER_HEIGHT');
  static const RenderBufferParameters RENDERBUFFER_GREEN_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_GREEN_SIZE,'RENDERBUFFER_GREEN_SIZE');
  static const RenderBufferParameters RENDERBUFFER_BLUE_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_BLUE_SIZE,'RENDERBUFFER_BLUE_SIZE');
  static const RenderBufferParameters RENDERBUFFER_RED_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_RED_SIZE,'RENDERBUFFER_RED_SIZE');
  static const RenderBufferParameters RENDERBUFFER_ALPHA_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_ALPHA_SIZE,'RENDERBUFFER_ALPHA_SIZE');
  static const RenderBufferParameters RENDERBUFFER_DEPTH_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_DEPTH_SIZE,'RENDERBUFFER_DEPTH_SIZE');
  static const RenderBufferParameters RENDERBUFFER_STENCIL_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_STENCIL_SIZE,'RENDERBUFFER_STENCIL_SIZE');
}

class RenderBufferTarget extends WebGLEnum{

  const RenderBufferTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(RenderBufferTarget, index);

  static const RenderBufferTarget RENDERBUFFER = const RenderBufferTarget(WebGL.RenderingContext.RENDERBUFFER,'RENDERBUFFER');
}

class RenderBufferInternalFormatType extends WebGLEnum{

  const RenderBufferInternalFormatType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(RenderBufferInternalFormatType, index);

  static const RenderBufferInternalFormatType RGBA4 = const RenderBufferInternalFormatType(WebGL.RenderingContext.RGBA4,'RGBA4');
  static const RenderBufferInternalFormatType RGB565 = const RenderBufferInternalFormatType(WebGL.RenderingContext.RGB565,'RGB565');
  static const RenderBufferInternalFormatType RGB5_A1 = const RenderBufferInternalFormatType(WebGL.RenderingContext.RGB5_A1,'RGB5_A1');
  static const RenderBufferInternalFormatType DEPTH_COMPONENT16 = const RenderBufferInternalFormatType(WebGL.RenderingContext.DEPTH_COMPONENT16,'DEPTH_COMPONENT16');
  static const RenderBufferInternalFormatType STENCIL_INDEX8 = const RenderBufferInternalFormatType(WebGL.RenderingContext.STENCIL_INDEX8,'STENCIL_INDEX8');
  static const RenderBufferInternalFormatType DEPTH_STENCIL = const RenderBufferInternalFormatType(WebGL.RenderingContext.DEPTH_STENCIL,'DEPTH_STENCIL');
}


//WebGLFrameBuffers


class FrameBufferStatus extends WebGLEnum{

  const FrameBufferStatus(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FrameBufferStatus, index);

  static const FrameBufferStatus FRAMEBUFFER_COMPLETE = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_COMPLETE, 'FRAMEBUFFER_COMPLETE');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT, 'FRAMEBUFFER_INCOMPLETE_ATTACHMENT');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT, 'FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_DIMENSIONS = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS, 'FRAMEBUFFER_INCOMPLETE_DIMENSIONS');
  static const FrameBufferStatus FRAMEBUFFER_UNSUPPORTED = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_UNSUPPORTED, 'FRAMEBUFFER_UNSUPPORTED');
}

class FrameBufferTarget extends WebGLEnum{

  const FrameBufferTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FrameBufferTarget, index);

  static const FrameBufferTarget FRAMEBUFFER = const FrameBufferTarget(WebGL.RenderingContext.FRAMEBUFFER, 'FRAMEBUFFER');
}

class FrameBufferAttachment extends WebGLEnum{

  const FrameBufferAttachment(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FrameBufferAttachment, index);

  static const FrameBufferAttachment COLOR_ATTACHMENT0 = const FrameBufferAttachment(WebGL.RenderingContext.COLOR_ATTACHMENT0, 'COLOR_ATTACHMENT0');
  static const FrameBufferAttachment DEPTH_ATTACHMENT = const FrameBufferAttachment(WebGL.RenderingContext.DEPTH_ATTACHMENT, 'DEPTH_ATTACHMENT');
  static const FrameBufferAttachment STENCIL_ATTACHMENT = const FrameBufferAttachment(WebGL.RenderingContext.STENCIL_ATTACHMENT, 'STENCIL_ATTACHMENT');
}

class FrameBufferAttachmentType extends WebGLEnum{

  const FrameBufferAttachmentType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FrameBufferAttachmentType, index);

  static const FrameBufferAttachmentType TEXTURE = const FrameBufferAttachmentType(WebGL.RenderingContext.TEXTURE, 'TEXTURE');
  static const FrameBufferAttachmentType RENDERBUFFER = const FrameBufferAttachmentType(WebGL.RenderingContext.RENDERBUFFER, 'RENDERBUFFER');
  static const FrameBufferAttachmentType NONE = const FrameBufferAttachmentType(WebGL.RenderingContext.NONE, 'NONE');
}

class FrameBufferAttachmentParameters extends WebGLEnum{

  const FrameBufferAttachmentParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(FrameBufferAttachmentParameters, index);

  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE, 'FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE');
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME, 'FRAMEBUFFER_ATTACHMENT_OBJECT_NAME');
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL, 'FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL');
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE, 'FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE');
}

class TextureAttachmentTarget extends WebGLEnum{

  const TextureAttachmentTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureAttachmentTarget, index);

  static const TextureAttachmentTarget TEXTURE_2D = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_2D, '');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_X = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X, 'TEXTURE_CUBE_MAP_POSITIVE_X');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_X = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 'TEXTURE_CUBE_MAP_NEGATIVE_X');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_Y = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 'TEXTURE_CUBE_MAP_POSITIVE_Y');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_Y = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 'TEXTURE_CUBE_MAP_NEGATIVE_Y');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_Z = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 'TEXTURE_CUBE_MAP_POSITIVE_Z');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_Z = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 'TEXTURE_CUBE_MAP_NEGATIVE_Z');
}


//WebGLBuffers


class BufferType extends WebGLEnum{

  const BufferType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(BufferType, index);

  static const BufferType ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ARRAY_BUFFER, 'ARRAY_BUFFER');
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, 'ELEMENT_ARRAY_BUFFER');
}

class BufferUsageType extends WebGLEnum{

  const BufferUsageType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(BufferUsageType, index);

  static const BufferUsageType STATIC_DRAW =
  const BufferUsageType(WebGL.RenderingContext.STATIC_DRAW, 'STATIC_DRAW');
  static const BufferUsageType DYNAMIC_DRAW =
  const BufferUsageType(WebGL.RenderingContext.DYNAMIC_DRAW, 'DYNAMIC_DRAW');
  static const BufferUsageType STREAM_DRAW =
  const BufferUsageType(WebGL.RenderingContext.STREAM_DRAW, 'STREAM_DRAW');
}

class BufferParameters extends WebGLEnum{

  const BufferParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(BufferParameters, index);

  static const BufferParameters BUFFER_SIZE = const BufferParameters(WebGL.RenderingContext.BUFFER_SIZE, 'BUFFER_SIZE');
  static const BufferParameters BUFFER_USAGE = const BufferParameters(WebGL.RenderingContext.BUFFER_USAGE, 'BUFFER_USAGE');
}


//WebGLPrograms


class ProgramParameterGlEnum extends WebGLEnum{

  const ProgramParameterGlEnum(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ProgramParameterGlEnum, index);

  static const ProgramParameterGlEnum DELETE_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.DELETE_STATUS, 'DELETE_STATUS');
  static const ProgramParameterGlEnum LINK_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.LINK_STATUS, 'LINK_STATUS');
  static const ProgramParameterGlEnum VALIDATE_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.VALIDATE_STATUS, 'VALIDATE_STATUS');
  static const ProgramParameterGlEnum ATTACHED_SHADERS = const ProgramParameterGlEnum(WebGL.RenderingContext.ATTACHED_SHADERS, 'ATTACHED_SHADERS');
  static const ProgramParameterGlEnum ACTIVE_ATTRIBUTES = const ProgramParameterGlEnum(WebGL.RenderingContext.ACTIVE_ATTRIBUTES, 'ACTIVE_ATTRIBUTES');
  static const ProgramParameterGlEnum ACTIVE_UNIFORMS = const ProgramParameterGlEnum(WebGL.RenderingContext.ACTIVE_UNIFORMS, 'ACTIVE_UNIFORMS');
}

class VertexAttribArrayType extends WebGLEnum{

  const VertexAttribArrayType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(VertexAttribArrayType, index);

  static const VertexAttribArrayType BYTE = const VertexAttribArrayType(WebGL.RenderingContext.BYTE, 'BYTE');
  static const VertexAttribArrayType UNSIGNED_BYTE = const VertexAttribArrayType(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const VertexAttribArrayType SHORT = const VertexAttribArrayType(WebGL.RenderingContext.SHORT, 'SHORT');
  static const VertexAttribArrayType UNSIGNED_SHORT = const VertexAttribArrayType(WebGL.RenderingContext.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static const VertexAttribArrayType FLOAT = const VertexAttribArrayType(WebGL.RenderingContext.FLOAT, 'FLOAT');
}


//WebGLTextures


class TextureParameterGlEnum extends WebGLEnum{

  const TextureParameterGlEnum(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureParameterGlEnum, index);

  static const TextureParameterGlEnum TEXTURE_MAG_FILTER =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_MAG_FILTER, 'TEXTURE_MAG_FILTER');
  static const TextureParameterGlEnum TEXTURE_MIN_FILTER =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_MIN_FILTER, 'TEXTURE_MIN_FILTER');
  static const TextureParameterGlEnum TEXTURE_WRAP_S =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_WRAP_S, 'TEXTURE_WRAP_S');
  static const TextureParameterGlEnum TEXTURE_WRAP_T =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_WRAP_T, 'TEXTURE_WRAP_T');
}

class TextureTarget extends WebGLEnum{

  const TextureTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureTarget, index);

  static const TextureTarget TEXTURE_2D =
  const TextureTarget(WebGL.RenderingContext.TEXTURE_2D, 'TEXTURE_2D');
  static const TextureTarget TEXTURE_CUBE_MAP =
  const TextureTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP, 'TEXTURE_CUBE_MAP');
}

abstract class TextureSetParameterType extends WebGLEnum{
  const TextureSetParameterType(int index, String name):super(index, name);
}
class TextureFilterType extends TextureSetParameterType {
  const TextureFilterType(int index, String name):super(index, name);
}

class TextureMagType extends TextureFilterType {
  const TextureMagType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureMagType, index);

  static const TextureMagType LINEAR =
  const TextureMagType(WebGL.RenderingContext.LINEAR,'LINEAR');
  static const TextureMagType NEAREST =
  const TextureMagType(WebGL.RenderingContext.NEAREST,'NEAREST');
}

class TextureMinType extends TextureFilterType {
  const TextureMinType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureMinType, index);

  static const TextureMinType LINEAR =
  const TextureMinType(WebGL.RenderingContext.LINEAR,'LINEAR');
  static const TextureMinType NEAREST =
  const TextureMinType(WebGL.RenderingContext.NEAREST, 'NEAREST');
  static const TextureMinType NEAREST_MIPMAP_NEAREST =
  const TextureMinType(WebGL.RenderingContext.NEAREST_MIPMAP_NEAREST, 'NEAREST_MIPMAP_NEAREST');
  static const TextureMinType LINEAR_MIPMAP_NEAREST =
  const TextureMinType(WebGL.RenderingContext.LINEAR_MIPMAP_NEAREST, 'LINEAR_MIPMAP_NEAREST');
  static const TextureMinType NEAREST_MIPMAP_LINEAR =
  const TextureMinType(WebGL.RenderingContext.NEAREST_MIPMAP_LINEAR, 'NEAREST_MIPMAP_LINEAR');
  static const TextureMinType LINEAR_MIPMAP_LINEAR =
  const TextureMinType(WebGL.RenderingContext.LINEAR_MIPMAP_LINEAR, 'LINEAR_MIPMAP_LINEAR');
}

class TextureWrapType extends TextureSetParameterType{
  const TextureWrapType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureWrapType, index);

  static const TextureWrapType REPEAT =
  const TextureWrapType(WebGL.RenderingContext.REPEAT, 'REPEAT');
  static const TextureWrapType CLAMP_TO_EDGE =
  const TextureWrapType(WebGL.RenderingContext.CLAMP_TO_EDGE, 'CLAMP_TO_EDGE');
  static const TextureWrapType MIRRORED_REPEAT =
  const TextureWrapType(WebGL.RenderingContext.MIRRORED_REPEAT, 'MIRRORED_REPEAT');
}

class TextureInternalFormatType extends WebGLEnum{

  const TextureInternalFormatType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureInternalFormatType, index);

  static const TextureInternalFormatType ALPHA = const TextureInternalFormatType(WebGL.RenderingContext.ALPHA, 'ALPHA');
  static const TextureInternalFormatType RGB = const TextureInternalFormatType(WebGL.RenderingContext.RGB, 'RGB');
  static const TextureInternalFormatType RGBA = const TextureInternalFormatType(WebGL.RenderingContext.RGBA, 'RGBA');
  static const TextureInternalFormatType LUMINANCE = const TextureInternalFormatType(WebGL.RenderingContext.LUMINANCE, 'LUMINANCE');
  static const TextureInternalFormatType LUMINANCE_ALPHA = const TextureInternalFormatType(WebGL.RenderingContext.LUMINANCE_ALPHA, 'LUMINANCE_ALPHA');
}

//Todo move in extension
class WEBGL_depth_texture_InternalFormatType extends TextureInternalFormatType{
  const WEBGL_depth_texture_InternalFormatType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(WEBGL_depth_texture_InternalFormatType, index);

  static const WEBGL_depth_texture_InternalFormatType DEPTH_COMPONENT = const WEBGL_depth_texture_InternalFormatType(WebGL.RenderingContext.DEPTH_COMPONENT,'DEPTH_COMPONENT');
  static const WEBGL_depth_texture_InternalFormatType DEPTH_STENCIL = const WEBGL_depth_texture_InternalFormatType(WebGL.RenderingContext.DEPTH_STENCIL,'DEPTH_STENCIL');
}

class TexelDataType extends WebGLEnum{

  const TexelDataType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TexelDataType, index);

  static const TexelDataType UNSIGNED_BYTE = const TexelDataType(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const TexelDataType UNSIGNED_SHORT_5_6_5 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5, 'UNSIGNED_SHORT_5_6_5');
  static const TexelDataType UNSIGNED_SHORT_4_4_4_4 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4, 'UNSIGNED_SHORT_4_4_4_4');
  static const TexelDataType UNSIGNED_SHORT_5_5_5_1 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1, 'UNSIGNED_SHORT_5_5_5_1');
}

class TextureUnit extends WebGLEnum{

  const TextureUnit(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(TextureUnit, index);

  static const TextureUnit TEXTURE0 = const TextureUnit(WebGL.RenderingContext.TEXTURE0, 'TEXTURE0');
  static const TextureUnit TEXTURE1 = const TextureUnit(WebGL.RenderingContext.TEXTURE1, 'TEXTURE1');
  static const TextureUnit TEXTURE2 = const TextureUnit(WebGL.RenderingContext.TEXTURE2, 'TEXTURE2');
  static const TextureUnit TEXTURE3 = const TextureUnit(WebGL.RenderingContext.TEXTURE3, 'TEXTURE3');
  static const TextureUnit TEXTURE4 = const TextureUnit(WebGL.RenderingContext.TEXTURE4, 'TEXTURE4');
  static const TextureUnit TEXTURE5 = const TextureUnit(WebGL.RenderingContext.TEXTURE5, 'TEXTURE5');
  static const TextureUnit TEXTURE6 = const TextureUnit(WebGL.RenderingContext.TEXTURE6, 'TEXTURE6');
  static const TextureUnit TEXTURE7 = const TextureUnit(WebGL.RenderingContext.TEXTURE7, 'TEXTURE7');
  static const TextureUnit TEXTURE8 = const TextureUnit(WebGL.RenderingContext.TEXTURE8, 'TEXTURE8');
  static const TextureUnit TEXTURE9 = const TextureUnit(WebGL.RenderingContext.TEXTURE9, 'TEXTURE9');
  static const TextureUnit TEXTURE10 = const TextureUnit(WebGL.RenderingContext.TEXTURE10, 'TEXTURE10');
  static const TextureUnit TEXTURE11 = const TextureUnit(WebGL.RenderingContext.TEXTURE11, 'TEXTURE11');
  static const TextureUnit TEXTURE12 = const TextureUnit(WebGL.RenderingContext.TEXTURE12, 'TEXTURE12');
  static const TextureUnit TEXTURE13 = const TextureUnit(WebGL.RenderingContext.TEXTURE13, 'TEXTURE13');
  static const TextureUnit TEXTURE14 = const TextureUnit(WebGL.RenderingContext.TEXTURE14, 'TEXTURE14');
  static const TextureUnit TEXTURE15 = const TextureUnit(WebGL.RenderingContext.TEXTURE15, 'TEXTURE15');
  static const TextureUnit TEXTURE16 = const TextureUnit(WebGL.RenderingContext.TEXTURE16, 'TEXTURE16');
  static const TextureUnit TEXTURE17 = const TextureUnit(WebGL.RenderingContext.TEXTURE17, 'TEXTURE17');
  static const TextureUnit TEXTURE18 = const TextureUnit(WebGL.RenderingContext.TEXTURE18, 'TEXTURE18');
  static const TextureUnit TEXTURE19 = const TextureUnit(WebGL.RenderingContext.TEXTURE19, 'TEXTURE19');
  static const TextureUnit TEXTURE20 = const TextureUnit(WebGL.RenderingContext.TEXTURE20, 'TEXTURE20');
  static const TextureUnit TEXTURE21 = const TextureUnit(WebGL.RenderingContext.TEXTURE21, 'TEXTURE21');
  static const TextureUnit TEXTURE22 = const TextureUnit(WebGL.RenderingContext.TEXTURE22, 'TEXTURE22');
  static const TextureUnit TEXTURE23 = const TextureUnit(WebGL.RenderingContext.TEXTURE23, 'TEXTURE23');
  static const TextureUnit TEXTURE24 = const TextureUnit(WebGL.RenderingContext.TEXTURE24, 'TEXTURE24');
  static const TextureUnit TEXTURE25 = const TextureUnit(WebGL.RenderingContext.TEXTURE25, 'TEXTURE25');
  static const TextureUnit TEXTURE26 = const TextureUnit(WebGL.RenderingContext.TEXTURE26, 'TEXTURE26');
  static const TextureUnit TEXTURE27 = const TextureUnit(WebGL.RenderingContext.TEXTURE27, 'TEXTURE27');
  static const TextureUnit TEXTURE28 = const TextureUnit(WebGL.RenderingContext.TEXTURE28, 'TEXTURE28');
  static const TextureUnit TEXTURE29 = const TextureUnit(WebGL.RenderingContext.TEXTURE29, 'TEXTURE29');
  static const TextureUnit TEXTURE30 = const TextureUnit(WebGL.RenderingContext.TEXTURE30, 'TEXTURE30');
  static const TextureUnit TEXTURE31 = const TextureUnit(WebGL.RenderingContext.TEXTURE31, 'TEXTURE31');
}


//WebGLShaders


class ShaderVariableType extends WebGLEnum{

  const ShaderVariableType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ShaderVariableType, index);

  static const ShaderVariableType FLOAT_VEC2 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_VEC2, 'FLOAT_VEC2');
  static const ShaderVariableType FLOAT_VEC3 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_VEC3, 'FLOAT_VEC3');
  static const ShaderVariableType FLOAT_VEC4 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_VEC4, 'FLOAT_VEC4');
  static const ShaderVariableType INT_VEC2 = const ShaderVariableType(WebGL.RenderingContext.INT_VEC2, 'INT_VEC2');
  static const ShaderVariableType INT_VEC3 = const ShaderVariableType(WebGL.RenderingContext.INT_VEC3, 'INT_VEC3');
  static const ShaderVariableType INT_VEC4 = const ShaderVariableType(WebGL.RenderingContext.INT_VEC4, 'INT_VEC4');
  static const ShaderVariableType BOOL = const ShaderVariableType(WebGL.RenderingContext.BOOL, 'BOOL');
  static const ShaderVariableType BOOL_VEC2 = const ShaderVariableType(WebGL.RenderingContext.BOOL_VEC2, 'BOOL_VEC2');
  static const ShaderVariableType BOOL_VEC3 = const ShaderVariableType(WebGL.RenderingContext.BOOL_VEC3, 'BOOL_VEC3');
  static const ShaderVariableType BOOL_VEC4 = const ShaderVariableType(WebGL.RenderingContext.BOOL_VEC4, 'BOOL_VEC4');
  static const ShaderVariableType FLOAT_MAT2 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_MAT2, 'FLOAT_MAT2');
  static const ShaderVariableType FLOAT_MAT3 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_MAT3, 'FLOAT_MAT3');
  static const ShaderVariableType FLOAT_MAT4 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_MAT4, 'FLOAT_MAT4');
  static const ShaderVariableType SAMPLER_2D = const ShaderVariableType(WebGL.RenderingContext.SAMPLER_2D, 'SAMPLER_2D');
  static const ShaderVariableType SAMPLER_CUBE = const ShaderVariableType(WebGL.RenderingContext.SAMPLER_CUBE, 'SAMPLER_CUBE');
  static const ShaderVariableType BYTE = const ShaderVariableType(WebGL.RenderingContext.BYTE, 'BYTE');
  static const ShaderVariableType UNSIGNED_BYTE = const ShaderVariableType(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const ShaderVariableType SHORT = const ShaderVariableType(WebGL.RenderingContext.SHORT, 'SHORT');
  static const ShaderVariableType UNSIGNED_SHORT = const ShaderVariableType(WebGL.RenderingContext.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static const ShaderVariableType INT = const ShaderVariableType(WebGL.RenderingContext.INT, 'INT');
  static const ShaderVariableType UNSIGNED_INT = const ShaderVariableType(WebGL.RenderingContext.UNSIGNED_INT, 'UNSIGNED_INT');
  static const ShaderVariableType FLOAT = const ShaderVariableType(WebGL.RenderingContext.FLOAT, 'FLOAT');
}

class PrecisionType extends WebGLEnum{

  const PrecisionType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(PrecisionType, index);

  static const PrecisionType LOW_INT = const PrecisionType(WebGL.RenderingContext.LOW_INT, 'LOW_INT');
  static const PrecisionType LOW_FLOAT = const PrecisionType(WebGL.RenderingContext.LOW_FLOAT, 'LOW_FLOAT');
  static const PrecisionType MEDIUM_INT = const PrecisionType(WebGL.RenderingContext.MEDIUM_INT, 'MEDIUM_INT');
  static const PrecisionType MEDIUM_FLOAT = const PrecisionType(WebGL.RenderingContext.MEDIUM_FLOAT, 'MEDIUM_FLOAT');
  static const PrecisionType HIGH_INT = const PrecisionType(WebGL.RenderingContext.HIGH_INT, 'HIGH_INT');
  static const PrecisionType HIGH_FLOAT = const PrecisionType(WebGL.RenderingContext.HIGH_FLOAT, 'HIGH_FLOAT');
}

class ShaderType extends WebGLEnum{

  const ShaderType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ShaderType, index);

  static const ShaderType FRAGMENT_SHADER = const ShaderType(WebGL.RenderingContext.FRAGMENT_SHADER, 'FRAGMENT_SHADER');
  static const ShaderType VERTEX_SHADER = const ShaderType(WebGL.RenderingContext.VERTEX_SHADER, 'VERTEX_SHADER');
}

class ShaderParameters extends WebGLEnum{

  const ShaderParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(ShaderParameters, index);

  static const ShaderParameters DELETE_STATUS = const ShaderParameters(WebGL.RenderingContext.DELETE_STATUS, 'DELETE_STATUS');
  static const ShaderParameters COMPILE_STATUS = const ShaderParameters(WebGL.RenderingContext.COMPILE_STATUS, 'COMPILE_STATUS');
  static const ShaderParameters SHADER_TYPE = const ShaderParameters(WebGL.RenderingContext.SHADER_TYPE, 'SHADER_TYPE');
}

class VertexAttribGlEnum extends WebGLEnum{

  const VertexAttribGlEnum(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum._findTypeByIndex(VertexAttribGlEnum, index);

  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,'VERTEX_ATTRIB_ARRAY_BUFFER_BINDING');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_ENABLED = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED, 'VERTEX_ATTRIB_ARRAY_ENABLED');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_SIZE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE, 'VERTEX_ATTRIB_ARRAY_SIZE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_STRIDE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE, 'VERTEX_ATTRIB_ARRAY_STRIDE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_TYPE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE, 'VERTEX_ATTRIB_ARRAY_TYPE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_NORMALIZED = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED, 'VERTEX_ATTRIB_ARRAY_NORMALIZED');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_POINTER = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER, 'VERTEX_ATTRIB_ARRAY_POINTER');
  static const VertexAttribGlEnum CURRENT_VERTEX_ATTRIB = const VertexAttribGlEnum(WebGL.RenderingContext.CURRENT_VERTEX_ATTRIB, 'CURRENT_VERTEX_ATTRIB');
}

