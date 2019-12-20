import 'dart:web_gl' as WebGL;
import 'package:webgl/src/introspection/introspection.dart';
import 'package:reflectable/reflectable.dart';

//@reflector
abstract class WebGLEnum {
  final int _index;
  final String _name;

  const WebGLEnum(this._index, this._name);

  int get index => _index;
  String get name => _name;

  @override
  String toString() {
    return '$_name : $_index';
  }

  static Map<Type, List<WebGLEnum>> typesMap = new Map();

  static WebGLEnum findTypeByIndex(Type GLEnum, int enumIndex) {
//     Todo (jpu) : Mirrors
//    throw new Exception("can't use mirrors throw by (jer) in webgl_enum_wrapped.dart > classMirror.getField");
    if (typesMap[GLEnum] == null) {
      List<WebGLEnum> _types = new List();
      ClassMirror classMirror = reflector.reflectType(GLEnum) as ClassMirror;
      List<MethodMirror> decls =
          classMirror.staticMembers.values.where((e) => e.isGetter).toList();

      decls.forEach((decl) => _types
          .add(classMirror.invokeGetter(decl.simpleName) as WebGLEnum));

      typesMap[GLEnum] = _types;
    }
    return typesMap[GLEnum].firstWhere(
        (WebGLEnum e) => e.runtimeType == GLEnum && e.index == enumIndex,
        orElse: () => null);
  }

  static List<WebGLEnum> getItems(Type GLEnum) {
//     Todo (jpu) : Mirrors
//    throw new Exception("can't use mirrors throw by (jer) in webgl_enum_wrapped.dart");
    if (typesMap[GLEnum] == null) {
      typesMap[GLEnum] = new List();
      ClassMirror classMirror = reflector.reflectType(GLEnum) as ClassMirror;
      List<MethodMirror> decls =
          classMirror.staticMembers.values.where((e) => e.isGetter).toList();

      decls.forEach((decl) => typesMap[GLEnum]
          .add(classMirror.invokeGetter(decl.simpleName) as WebGLEnum));
    }
    return typesMap[GLEnum]
        .where((WebGLEnum e) => e.runtimeType == GLEnum)
        .toList();
  }
}

//WebGLRenderingContext

//@reflector
class EnableCapabilityType extends WebGLEnum {
  const EnableCapabilityType(int index, String name) : super(index, name);

  static EnableCapabilityType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(EnableCapabilityType, index)
          as EnableCapabilityType;

  static const EnableCapabilityType BLEND =
      const EnableCapabilityType(WebGL.WebGL.BLEND, 'BLEND');
  static const EnableCapabilityType CULL_FACE =
      const EnableCapabilityType(WebGL.WebGL.CULL_FACE, 'CULL_FACE');
  static const EnableCapabilityType DEPTH_TEST = const EnableCapabilityType(
      WebGL.WebGL.DEPTH_TEST, 'DEPTH_TEST');
  static const EnableCapabilityType DITHER = const EnableCapabilityType(
      WebGL.WebGL.DITHER, 'DITHER'); //Todo : add enabling ?
  static const EnableCapabilityType POLYGON_OFFSET_FILL =
      const EnableCapabilityType(
          WebGL.WebGL.POLYGON_OFFSET_FILL, 'POLYGON_OFFSET_FILL');
  static const EnableCapabilityType SAMPLE_ALPHA_TO_COVERAGE =
      const EnableCapabilityType(
          WebGL.WebGL.SAMPLE_ALPHA_TO_COVERAGE,
          'SAMPLE_ALPHA_TO_COVERAGE');
  static const EnableCapabilityType SAMPLE_COVERAGE =
      const EnableCapabilityType(
          WebGL.WebGL.SAMPLE_COVERAGE, 'SAMPLE_COVERAGE');
  static const EnableCapabilityType SCISSOR_TEST = const EnableCapabilityType(
      WebGL.WebGL.SCISSOR_TEST, 'SCISSOR_TEST');
  static const EnableCapabilityType STENCIL_TEST = const EnableCapabilityType(
      WebGL.WebGL.STENCIL_TEST, 'STENCIL_TEST');
}

//@reflector
class FacingType extends WebGLEnum {
  const FacingType(int index, String name) : super(index, name);
  static FacingType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FacingType, index) as FacingType;

  int call(){
    return index;
  }
  static const FacingType FRONT =
      const FacingType(WebGL.WebGL.FRONT, 'FRONT');
  static const FacingType BACK =
      const FacingType(WebGL.WebGL.BACK, 'BACK');
  static const FacingType FRONT_AND_BACK =
      const FacingType(WebGL.WebGL.FRONT_AND_BACK, 'FRONT_AND_BACK');
}

//@reflector
class ClearBufferMask extends WebGLEnum {
  const ClearBufferMask(int index, String name) : super(index, name);
  static ClearBufferMask getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ClearBufferMask, index) as ClearBufferMask;

  static const ClearBufferMask DEPTH_BUFFER_BIT = const ClearBufferMask(
      WebGL.WebGL.DEPTH_BUFFER_BIT, 'DEPTH_BUFFER_BIT');
  static const ClearBufferMask STENCIL_BUFFER_BIT = const ClearBufferMask(
      WebGL.WebGL.STENCIL_BUFFER_BIT, 'STENCIL_BUFFER_BIT');
  static const ClearBufferMask COLOR_BUFFER_BIT = const ClearBufferMask(
      WebGL.WebGL.COLOR_BUFFER_BIT, 'COLOR_BUFFER_BIT');
}

//@reflector
class FrontFaceDirection extends WebGLEnum {
  const FrontFaceDirection(int index, String name) : super(index, name);
  static FrontFaceDirection getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FrontFaceDirection, index)
          as FrontFaceDirection;

  static const FrontFaceDirection CW =
      const FrontFaceDirection(WebGL.WebGL.CW, 'CW');
  static const FrontFaceDirection CCW =
      const FrontFaceDirection(WebGL.WebGL.CCW, 'CCW');
}

//@reflector
class PixelStorgeType extends WebGLEnum {
  const PixelStorgeType(int index, String name) : super(index, name);
  static PixelStorgeType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(PixelStorgeType, index) as PixelStorgeType;

  static const PixelStorgeType PACK_ALIGNMENT = const PixelStorgeType(
      WebGL.WebGL.PACK_ALIGNMENT, 'PACK_ALIGNMENT');
  static const PixelStorgeType UNPACK_ALIGNMENT = const PixelStorgeType(
      WebGL.WebGL.UNPACK_ALIGNMENT, 'UNPACK_ALIGNMENT');
  static const PixelStorgeType UNPACK_FLIP_Y_WEBGL = const PixelStorgeType(
      WebGL.WebGL.UNPACK_FLIP_Y_WEBGL, 'UNPACK_FLIP_Y_WEBGL');
  static const PixelStorgeType UNPACK_PREMULTIPLY_ALPHA_WEBGL =
      const PixelStorgeType(
          WebGL.WebGL.UNPACK_PREMULTIPLY_ALPHA_WEBGL,
          'UNPACK_PREMULTIPLY_ALPHA_WEBGL');
  static const PixelStorgeType UNPACK_COLORSPACE_CONVERSION_WEBGL =
      const PixelStorgeType(
          WebGL.WebGL.UNPACK_COLORSPACE_CONVERSION_WEBGL,
          'UNPACK_COLORSPACE_CONVERSION_WEBGL');
}

//@reflector
class DrawMode extends WebGLEnum {
  const DrawMode(int index, String name) : super(index, name);
  static DrawMode getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(DrawMode, index) as DrawMode;

  static const DrawMode POINTS =
      const DrawMode(WebGL.WebGL.POINTS, 'POINTS');
  static const DrawMode LINE_STRIP =
      const DrawMode(WebGL.WebGL.LINE_STRIP, 'LINE_STRIP');
  static const DrawMode LINE_LOOP =
      const DrawMode(WebGL.WebGL.LINE_LOOP, 'LINE_LOOP');
  static const DrawMode LINES =
      const DrawMode(WebGL.WebGL.LINES, 'LINES');
  static const DrawMode TRIANGLE_STRIP =
      const DrawMode(WebGL.WebGL.TRIANGLE_STRIP, 'TRIANGLE_STRIP');
  static const DrawMode TRIANGLE_FAN =
      const DrawMode(WebGL.WebGL.TRIANGLE_FAN, 'TRIANGLE_FAN');
  static const DrawMode TRIANGLES =
      const DrawMode(WebGL.WebGL.TRIANGLES, 'TRIANGLES');
}

//@reflector
class BufferElementType extends WebGLEnum {
  const BufferElementType(int index, String name) : super(index, name);
  static BufferElementType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(BufferElementType, index) as BufferElementType;

  static const BufferElementType UNSIGNED_BYTE = const BufferElementType(
      WebGL.WebGL.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const BufferElementType UNSIGNED_SHORT = const BufferElementType(
      WebGL.WebGL.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
}

//@reflector
class ReadPixelDataFormat extends WebGLEnum {
  const ReadPixelDataFormat(int index, String name) : super(index, name);
  static ReadPixelDataFormat getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ReadPixelDataFormat, index)
          as ReadPixelDataFormat;

  static const ReadPixelDataFormat ALPHA =
      const ReadPixelDataFormat(WebGL.WebGL.ALPHA, 'ALPHA');
  static const ReadPixelDataFormat RGB =
      const ReadPixelDataFormat(WebGL.WebGL.RGB, 'RGB');
  static const ReadPixelDataFormat RGBA =
      const ReadPixelDataFormat(WebGL.WebGL.RGBA, 'RGBA');
}

//@reflector
class ReadPixelDataType extends WebGLEnum {
  const ReadPixelDataType(int index, String name) : super(index, name);
  static ReadPixelDataType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ReadPixelDataType, index) as ReadPixelDataType;

  static const ReadPixelDataType UNSIGNED_BYTE = const ReadPixelDataType(
      WebGL.WebGL.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const ReadPixelDataType UNSIGNED_SHORT_5_6_5 = const ReadPixelDataType(
      WebGL.WebGL.UNSIGNED_SHORT_5_6_5, 'UNSIGNED_SHORT_5_6_5');
  static const ReadPixelDataType UNSIGNED_SHORT_4_4_4_4 =
      const ReadPixelDataType(WebGL.WebGL.UNSIGNED_SHORT_4_4_4_4,
          'UNSIGNED_SHORT_4_4_4_4');
  static const ReadPixelDataType UNSIGNED_SHORT_5_5_5_1 =
      const ReadPixelDataType(WebGL.WebGL.UNSIGNED_SHORT_5_5_5_1,
          'UNSIGNED_SHORT_5_5_5_1');
  static const ReadPixelDataType FLOAT =
      const ReadPixelDataType(WebGL.WebGL.FLOAT, 'FLOAT');
}

//@reflector
class ComparisonFunction extends WebGLEnum {
  const ComparisonFunction(int index, String name) : super(index, name);
  static ComparisonFunction getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ComparisonFunction, index)
          as ComparisonFunction;

  static const ComparisonFunction NEVER =
      const ComparisonFunction(WebGL.WebGL.NEVER, 'NEVER');
  static const ComparisonFunction LESS =
      const ComparisonFunction(WebGL.WebGL.LESS, 'LESS');
  static const ComparisonFunction EQUAL =
      const ComparisonFunction(WebGL.WebGL.EQUAL, 'EQUAL');
  static const ComparisonFunction LEQUAL =
      const ComparisonFunction(WebGL.WebGL.LEQUAL, 'LEQUAL');
  static const ComparisonFunction GREATER =
      const ComparisonFunction(WebGL.WebGL.GREATER, 'GREATER');
  static const ComparisonFunction NOTEQUAL =
      const ComparisonFunction(WebGL.WebGL.NOTEQUAL, 'NOTEQUAL');
  static const ComparisonFunction GEQUAL =
      const ComparisonFunction(WebGL.WebGL.GEQUAL, 'GEQUAL');
  static const ComparisonFunction ALWAYS =
      const ComparisonFunction(WebGL.WebGL.ALWAYS, 'ALWAYS');
}

//@reflector
class ErrorCode extends WebGLEnum {
  const ErrorCode(int index, String name) : super(index, name);
  static ErrorCode getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ErrorCode, index) as ErrorCode;

  static const ErrorCode NO_ERROR =
      const ErrorCode(WebGL.WebGL.NO_ERROR, 'NO_ERROR');
  static const ErrorCode INVALID_ENUM =
      const ErrorCode(WebGL.WebGL.INVALID_ENUM, 'INVALID_ENUM');
  static const ErrorCode INVALID_VALUE =
      const ErrorCode(WebGL.WebGL.INVALID_VALUE, 'INVALID_VALUE');
  static const ErrorCode INVALID_OPERATION = const ErrorCode(
      WebGL.WebGL.INVALID_OPERATION, 'INVALID_OPERATION');
  static const ErrorCode INVALID_FRAMEBUFFER_OPERATION = const ErrorCode(
      WebGL.WebGL.INVALID_FRAMEBUFFER_OPERATION,
      'INVALID_FRAMEBUFFER_OPERATION');
  static const ErrorCode OUT_OF_MEMORY =
      const ErrorCode(WebGL.WebGL.OUT_OF_MEMORY, 'OUT_OF_MEMORY');
  static const ErrorCode CONTEXT_LOST_WEBGL = const ErrorCode(
      WebGL.WebGL.CONTEXT_LOST_WEBGL, 'CONTEXT_LOST_WEBGL');
}

//@reflector
class HintMode extends WebGLEnum {
  const HintMode(int index, String name) : super(index, name);
  static HintMode getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(HintMode, index) as HintMode;

  static const HintMode FASTEST =
      const HintMode(WebGL.WebGL.FASTEST, 'FASTEST');
  static const HintMode NICEST =
      const HintMode(WebGL.WebGL.NICEST, 'NICEST');
  static const HintMode DONT_CARE =
      const HintMode(WebGL.WebGL.DONT_CARE, 'DONT_CARE');
}

//@reflector
class StencilOpMode extends WebGLEnum {
  const StencilOpMode(int index, String name) : super(index, name);
  static StencilOpMode getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(StencilOpMode, index) as StencilOpMode;

  static const StencilOpMode ZERO =
      const StencilOpMode(WebGL.WebGL.ZERO, 'ZERO');
  static const StencilOpMode KEEP =
      const StencilOpMode(WebGL.WebGL.KEEP, 'KEEP');
  static const StencilOpMode REPLACE =
      const StencilOpMode(WebGL.WebGL.REPLACE, 'REPLACE');
  static const StencilOpMode INVERT =
      const StencilOpMode(WebGL.WebGL.INVERT, 'INVERT');
  static const StencilOpMode INCR =
      const StencilOpMode(WebGL.WebGL.INCR, 'INCR');
  static const StencilOpMode INCR_WRAP =
      const StencilOpMode(WebGL.WebGL.INCR_WRAP, 'INCR_WRAP');
  static const StencilOpMode DECR =
      const StencilOpMode(WebGL.WebGL.DECR, 'DECR');
  static const StencilOpMode DECR_WRAP =
      const StencilOpMode(WebGL.WebGL.DECR_WRAP, 'DECR_WRAP');
}

//@reflector
class BlendFactorMode extends WebGLEnum {
  const BlendFactorMode(int index, String name) : super(index, name);
  static BlendFactorMode getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(BlendFactorMode, index) as BlendFactorMode;

  static const BlendFactorMode ZERO =
      const BlendFactorMode(WebGL.WebGL.ZERO, 'ZERO');
  static const BlendFactorMode ONE =
      const BlendFactorMode(WebGL.WebGL.ONE, 'ONE');
  static const BlendFactorMode SRC_COLOR =
      const BlendFactorMode(WebGL.WebGL.SRC_COLOR, 'SRC_COLOR');
  static const BlendFactorMode SRC_ALPHA =
      const BlendFactorMode(WebGL.WebGL.SRC_ALPHA, 'SRC_ALPHA');
  static const BlendFactorMode SRC_ALPHA_SATURATE = const BlendFactorMode(
      WebGL.WebGL.SRC_ALPHA_SATURATE, 'SRC_ALPHA_SATURATE');
  static const BlendFactorMode DST_COLOR =
      const BlendFactorMode(WebGL.WebGL.DST_COLOR, 'DST_COLOR');
  static const BlendFactorMode DST_ALPHA =
      const BlendFactorMode(WebGL.WebGL.DST_ALPHA, 'DST_ALPHA');
  static const BlendFactorMode CONSTANT_COLOR = const BlendFactorMode(
      WebGL.WebGL.CONSTANT_COLOR, 'CONSTANT_COLOR');
  static const BlendFactorMode CONSTANT_ALPHA = const BlendFactorMode(
      WebGL.WebGL.CONSTANT_ALPHA, 'CONSTANT_ALPHA');
  static const BlendFactorMode ONE_MINUS_SRC_COLOR = const BlendFactorMode(
      WebGL.WebGL.ONE_MINUS_SRC_COLOR, 'ONE_MINUS_SRC_COLOR');
  static const BlendFactorMode ONE_MINUS_SRC_ALPHA = const BlendFactorMode(
      WebGL.WebGL.ONE_MINUS_SRC_ALPHA, 'ONE_MINUS_SRC_ALPHA');
  static const BlendFactorMode ONE_MINUS_DST_COLOR = const BlendFactorMode(
      WebGL.WebGL.ONE_MINUS_DST_COLOR, 'ONE_MINUS_DST_COLOR');
  static const BlendFactorMode ONE_MINUS_DST_ALPHA = const BlendFactorMode(
      WebGL.WebGL.ONE_MINUS_DST_ALPHA, 'ONE_MINUS_DST_ALPHA');
  static const BlendFactorMode ONE_MINUS_CONSTANT_COLOR = const BlendFactorMode(
      WebGL.WebGL.ONE_MINUS_CONSTANT_COLOR,
      'ONE_MINUS_CONSTANT_COLOR');
  static const BlendFactorMode ONE_MINUS_CONSTANT_ALPHA = const BlendFactorMode(
      WebGL.WebGL.ONE_MINUS_CONSTANT_ALPHA,
      'ONE_MINUS_CONSTANT_ALPHA');
}

//@reflector
class BlendFunctionMode extends WebGLEnum {
  const BlendFunctionMode(int index, String name) : super(index, name);
  static BlendFunctionMode getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(BlendFunctionMode, index) as BlendFunctionMode;

  static const BlendFunctionMode FUNC_ADD =
      const BlendFunctionMode(WebGL.WebGL.FUNC_ADD, 'FUNC_ADD');
  static const BlendFunctionMode FUNC_SUBTRACT = const BlendFunctionMode(
      WebGL.WebGL.FUNC_SUBTRACT, 'FUNC_SUBTRACT');
  static const BlendFunctionMode FUNC_REVERSE_SUBTRACT =
      const BlendFunctionMode(WebGL.WebGL.FUNC_REVERSE_SUBTRACT,
          'FUNC_REVERSE_SUBTRACT');
}

//@reflector
class ContextParameter extends WebGLEnum {
  const ContextParameter(int index, String name) : super(index, name);
  static ContextParameter getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ContextParameter, index) as ContextParameter;

  static const ContextParameter ACTIVE_TEXTURE = const ContextParameter(
      WebGL.WebGL.ACTIVE_TEXTURE, 'ACTIVE_TEXTURE');
  static const ContextParameter ALIASED_LINE_WIDTH_RANGE =
      const ContextParameter(WebGL.WebGL.ALIASED_LINE_WIDTH_RANGE,
          'ALIASED_LINE_WIDTH_RANGE');
  static const ContextParameter ALIASED_POINT_SIZE_RANGE =
      const ContextParameter(WebGL.WebGL.ALIASED_POINT_SIZE_RANGE,
          'ALIASED_POINT_SIZE_RANGE');
  static const ContextParameter ALPHA_BITS =
      const ContextParameter(WebGL.WebGL.ALPHA_BITS, 'ALPHA_BITS');
  static const ContextParameter ARRAY_BUFFER_BINDING = const ContextParameter(
      WebGL.WebGL.ARRAY_BUFFER_BINDING, 'ARRAY_BUFFER_BINDING');
  static const ContextParameter BLEND =
      const ContextParameter(WebGL.WebGL.BLEND, 'BLEND');
  static const ContextParameter BLEND_COLOR =
      const ContextParameter(WebGL.WebGL.BLEND_COLOR, 'BLEND_COLOR');
  static const ContextParameter BLEND_DST_ALPHA = const ContextParameter(
      WebGL.WebGL.BLEND_DST_ALPHA, 'BLEND_DST_ALPHA');
  static const ContextParameter BLEND_DST_RGB = const ContextParameter(
      WebGL.WebGL.BLEND_DST_RGB, 'BLEND_DST_RGB');
  static const ContextParameter BLEND_EQUATION = const ContextParameter(
      WebGL.WebGL.BLEND_EQUATION, 'BLEND_EQUATION');
  static const ContextParameter BLEND_EQUATION_ALPHA = const ContextParameter(
      WebGL.WebGL.BLEND_EQUATION_ALPHA, 'BLEND_EQUATION_ALPHA');
  static const ContextParameter BLEND_EQUATION_RGB = const ContextParameter(
      WebGL.WebGL.BLEND_EQUATION_RGB, 'BLEND_EQUATION_RGB');
  static const ContextParameter BLEND_SRC_ALPHA = const ContextParameter(
      WebGL.WebGL.BLEND_SRC_ALPHA, 'BLEND_SRC_ALPHA');
  static const ContextParameter BLEND_SRC_RGB = const ContextParameter(
      WebGL.WebGL.BLEND_SRC_RGB, 'BLEND_SRC_RGB');
  static const ContextParameter BLUE_BITS =
      const ContextParameter(WebGL.WebGL.BLUE_BITS, 'BLUE_BITS');
  static const ContextParameter COLOR_CLEAR_VALUE = const ContextParameter(
      WebGL.WebGL.COLOR_CLEAR_VALUE, 'COLOR_CLEAR_VALUE');
  static const ContextParameter COLOR_WRITEMASK = const ContextParameter(
      WebGL.WebGL.COLOR_WRITEMASK, 'COLOR_WRITEMASK');
  static const ContextParameter COMPRESSED_TEXTURE_FORMATS =
      const ContextParameter(WebGL.WebGL.COMPRESSED_TEXTURE_FORMATS,
          'COMPRESSED_TEXTURE_FORMATS');
  static const ContextParameter CULL_FACE_MODE = const ContextParameter(
      WebGL.WebGL.CULL_FACE_MODE, 'CULL_FACE_MODE');
  static const ContextParameter CURRENT_PROGRAM = const ContextParameter(
      WebGL.WebGL.CURRENT_PROGRAM, 'CURRENT_PROGRAM');
  static const ContextParameter DEPTH_BITS =
      const ContextParameter(WebGL.WebGL.DEPTH_BITS, 'DEPTH_BITS');
  static const ContextParameter DEPTH_CLEAR_VALUE = const ContextParameter(
      WebGL.WebGL.DEPTH_CLEAR_VALUE, 'DEPTH_CLEAR_VALUE');
  static const ContextParameter DEPTH_FUNC =
      const ContextParameter(WebGL.WebGL.DEPTH_FUNC, 'DEPTH_FUNC');
  static const ContextParameter DEPTH_RANGE =
      const ContextParameter(WebGL.WebGL.DEPTH_RANGE, 'DEPTH_RANGE');
  static const ContextParameter DEPTH_TEST =
      const ContextParameter(WebGL.WebGL.DEPTH_TEST, 'DEPTH_TEST');
  static const ContextParameter DEPTH_WRITEMASK = const ContextParameter(
      WebGL.WebGL.DEPTH_WRITEMASK, 'DEPTH_WRITEMASK');
  static const ContextParameter DITHER =
      const ContextParameter(WebGL.WebGL.DITHER, 'DITHER');
  static const ContextParameter ELEMENT_ARRAY_BUFFER_BINDING =
      const ContextParameter(
          WebGL.WebGL.ELEMENT_ARRAY_BUFFER_BINDING,
          'ELEMENT_ARRAY_BUFFER_BINDING');
  static const ContextParameter FRAMEBUFFER_BINDING = const ContextParameter(
      WebGL.WebGL.FRAMEBUFFER_BINDING, 'FRAMEBUFFER_BINDING');
  static const ContextParameter FRONT_FACE =
      const ContextParameter(WebGL.WebGL.FRONT_FACE, 'FRONT_FACE');
  static const ContextParameter GENERATE_MIPMAP_HINT = const ContextParameter(
      WebGL.WebGL.GENERATE_MIPMAP_HINT, 'GENERATE_MIPMAP_HINT');
  static const ContextParameter GREEN_BITS =
      const ContextParameter(WebGL.WebGL.GREEN_BITS, 'GREEN_BITS');
  static const ContextParameter IMPLEMENTATION_COLOR_READ_FORMAT =
      const ContextParameter(
          WebGL.WebGL.IMPLEMENTATION_COLOR_READ_FORMAT,
          'IMPLEMENTATION_COLOR_READ_FORMAT');
  static const ContextParameter IMPLEMENTATION_COLOR_READ_TYPE =
      const ContextParameter(
          WebGL.WebGL.IMPLEMENTATION_COLOR_READ_TYPE,
          'IMPLEMENTATION_COLOR_READ_TYPE');
  static const ContextParameter LINE_WIDTH =
      const ContextParameter(WebGL.WebGL.LINE_WIDTH, 'LINE_WIDTH');
  static const ContextParameter MAX_COMBINED_TEXTURE_IMAGE_UNITS =
      const ContextParameter(
          WebGL.WebGL.MAX_COMBINED_TEXTURE_IMAGE_UNITS,
          'MAX_COMBINED_TEXTURE_IMAGE_UNITS');
  static const ContextParameter MAX_CUBE_MAP_TEXTURE_SIZE =
      const ContextParameter(WebGL.WebGL.MAX_CUBE_MAP_TEXTURE_SIZE,
          'MAX_CUBE_MAP_TEXTURE_SIZE');
  static const ContextParameter MAX_FRAGMENT_UNIFORM_VECTORS =
      const ContextParameter(
          WebGL.WebGL.MAX_FRAGMENT_UNIFORM_VECTORS,
          'MAX_FRAGMENT_UNIFORM_VECTORS');
  static const ContextParameter MAX_RENDERBUFFER_SIZE = const ContextParameter(
      WebGL.WebGL.MAX_RENDERBUFFER_SIZE, 'MAX_RENDERBUFFER_SIZE');
  static const ContextParameter MAX_TEXTURE_IMAGE_UNITS =
      const ContextParameter(WebGL.WebGL.MAX_TEXTURE_IMAGE_UNITS,
          'MAX_TEXTURE_IMAGE_UNITS');
  static const ContextParameter MAX_TEXTURE_SIZE = const ContextParameter(
      WebGL.WebGL.MAX_TEXTURE_SIZE, 'MAX_TEXTURE_SIZE');
  static const ContextParameter MAX_VARYING_VECTORS = const ContextParameter(
      WebGL.WebGL.MAX_VARYING_VECTORS, 'MAX_VARYING_VECTORS');
  static const ContextParameter MAX_VERTEX_ATTRIBS = const ContextParameter(
      WebGL.WebGL.MAX_VERTEX_ATTRIBS, 'MAX_VERTEX_ATTRIBS');
  static const ContextParameter MAX_VERTEX_TEXTURE_IMAGE_UNITS =
      const ContextParameter(
          WebGL.WebGL.MAX_VERTEX_TEXTURE_IMAGE_UNITS,
          'MAX_VERTEX_TEXTURE_IMAGE_UNITS');
  static const ContextParameter MAX_VERTEX_UNIFORM_VECTORS =
      const ContextParameter(WebGL.WebGL.MAX_VERTEX_UNIFORM_VECTORS,
          'MAX_VERTEX_UNIFORM_VECTORS');
  static const ContextParameter MAX_VIEWPORT_DIMS = const ContextParameter(
      WebGL.WebGL.MAX_VIEWPORT_DIMS, 'MAX_VIEWPORT_DIMS');
  static const ContextParameter PACK_ALIGNMENT = const ContextParameter(
      WebGL.WebGL.PACK_ALIGNMENT, 'PACK_ALIGNMENT');
  static const ContextParameter POLYGON_OFFSET_FACTOR = const ContextParameter(
      WebGL.WebGL.POLYGON_OFFSET_FACTOR, 'POLYGON_OFFSET_FACTOR');
  static const ContextParameter POLYGON_OFFSET_FILL = const ContextParameter(
      WebGL.WebGL.POLYGON_OFFSET_FILL, 'POLYGON_OFFSET_FILL');
  static const ContextParameter POLYGON_OFFSET_UNITS = const ContextParameter(
      WebGL.WebGL.POLYGON_OFFSET_UNITS, 'POLYGON_OFFSET_UNITS');
  static const ContextParameter RED_BITS =
      const ContextParameter(WebGL.WebGL.RED_BITS, 'RED_BITS');
  static const ContextParameter RENDERBUFFER_BINDING = const ContextParameter(
      WebGL.WebGL.RENDERBUFFER_BINDING, 'RENDERBUFFER_BINDING');
  static const ContextParameter RENDERER =
      const ContextParameter(WebGL.WebGL.RENDERER, 'RENDERER');
  static const ContextParameter SAMPLE_BUFFERS = const ContextParameter(
      WebGL.WebGL.SAMPLE_BUFFERS, 'SAMPLE_BUFFERS');
  static const ContextParameter SAMPLE_COVERAGE_INVERT = const ContextParameter(
      WebGL.WebGL.SAMPLE_COVERAGE_INVERT, 'SAMPLE_COVERAGE_INVERT');
  static const ContextParameter SAMPLE_COVERAGE_VALUE = const ContextParameter(
      WebGL.WebGL.SAMPLE_COVERAGE_VALUE, 'SAMPLE_COVERAGE_VALUE');
  static const ContextParameter SAMPLES =
      const ContextParameter(WebGL.WebGL.SAMPLES, 'SAMPLES');
  static const ContextParameter SCISSOR_BOX =
      const ContextParameter(WebGL.WebGL.SCISSOR_BOX, 'SCISSOR_BOX');
  static const ContextParameter SCISSOR_TEST = const ContextParameter(
      WebGL.WebGL.SCISSOR_TEST, 'SCISSOR_TEST');
  static const ContextParameter SHADING_LANGUAGE_VERSION =
      const ContextParameter(WebGL.WebGL.SHADING_LANGUAGE_VERSION,
          'SHADING_LANGUAGE_VERSION');
  static const ContextParameter STENCIL_BACK_FAIL = const ContextParameter(
      WebGL.WebGL.STENCIL_BACK_FAIL, 'STENCIL_BACK_FAIL');
  static const ContextParameter STENCIL_BACK_FUNC = const ContextParameter(
      WebGL.WebGL.STENCIL_BACK_FUNC, 'STENCIL_BACK_FUNC');
  static const ContextParameter STENCIL_BACK_PASS_DEPTH_FAIL =
      const ContextParameter(
          WebGL.WebGL.STENCIL_BACK_PASS_DEPTH_FAIL,
          'STENCIL_BACK_PASS_DEPTH_FAIL');
  static const ContextParameter STENCIL_BACK_PASS_DEPTH_PASS =
      const ContextParameter(
          WebGL.WebGL.STENCIL_BACK_PASS_DEPTH_PASS,
          'STENCIL_BACK_PASS_DEPTH_PASS');
  static const ContextParameter STENCIL_BACK_REF = const ContextParameter(
      WebGL.WebGL.STENCIL_BACK_REF, 'STENCIL_BACK_REF');
  static const ContextParameter STENCIL_BACK_VALUE_MASK =
      const ContextParameter(WebGL.WebGL.STENCIL_BACK_VALUE_MASK,
          'STENCIL_BACK_VALUE_MASK');
  static const ContextParameter STENCIL_BACK_WRITEMASK = const ContextParameter(
      WebGL.WebGL.STENCIL_BACK_WRITEMASK, 'STENCIL_BACK_WRITEMASK');
  static const ContextParameter STENCIL_BITS = const ContextParameter(
      WebGL.WebGL.STENCIL_BITS, 'STENCIL_BITS');
  static const ContextParameter STENCIL_CLEAR_VALUE = const ContextParameter(
      WebGL.WebGL.STENCIL_CLEAR_VALUE, 'STENCIL_CLEAR_VALUE');
  static const ContextParameter STENCIL_FAIL = const ContextParameter(
      WebGL.WebGL.STENCIL_FAIL, 'STENCIL_FAIL');
  static const ContextParameter STENCIL_FUNC = const ContextParameter(
      WebGL.WebGL.STENCIL_FUNC, 'STENCIL_FUNC');
  static const ContextParameter STENCIL_PASS_DEPTH_FAIL =
      const ContextParameter(WebGL.WebGL.STENCIL_PASS_DEPTH_FAIL,
          'STENCIL_PASS_DEPTH_FAIL');
  static const ContextParameter STENCIL_PASS_DEPTH_PASS =
      const ContextParameter(WebGL.WebGL.STENCIL_PASS_DEPTH_PASS,
          'STENCIL_PASS_DEPTH_PASS');
  static const ContextParameter STENCIL_REF =
      const ContextParameter(WebGL.WebGL.STENCIL_REF, 'STENCIL_REF');
  static const ContextParameter STENCIL_TEST = const ContextParameter(
      WebGL.WebGL.STENCIL_TEST, 'STENCIL_TEST');
  static const ContextParameter STENCIL_VALUE_MASK = const ContextParameter(
      WebGL.WebGL.STENCIL_VALUE_MASK, 'STENCIL_VALUE_MASK');
  static const ContextParameter STENCIL_WRITEMASK = const ContextParameter(
      WebGL.WebGL.STENCIL_WRITEMASK, 'STENCIL_WRITEMASK');
  static const ContextParameter SUBPIXEL_BITS = const ContextParameter(
      WebGL.WebGL.SUBPIXEL_BITS, 'SUBPIXEL_BITS');
  static const ContextParameter TEXTURE_BINDING_2D = const ContextParameter(
      WebGL.WebGL.TEXTURE_BINDING_2D, 'TEXTURE_BINDING_2D');
  static const ContextParameter TEXTURE_BINDING_CUBE_MAP =
      const ContextParameter(WebGL.WebGL.TEXTURE_BINDING_CUBE_MAP,
          'TEXTURE_BINDING_CUBE_MAP');
  static const ContextParameter UNPACK_ALIGNMENT = const ContextParameter(
      WebGL.WebGL.UNPACK_ALIGNMENT, 'UNPACK_ALIGNMENT');
  static const ContextParameter UNPACK_COLORSPACE_CONVERSION_WEBGL =
      const ContextParameter(
          WebGL.WebGL.UNPACK_COLORSPACE_CONVERSION_WEBGL,
          'UNPACK_COLORSPACE_CONVERSION_WEBGL');
  static const ContextParameter UNPACK_FLIP_Y_WEBGL = const ContextParameter(
      WebGL.WebGL.UNPACK_FLIP_Y_WEBGL, 'UNPACK_FLIP_Y_WEBGL');
  static const ContextParameter UNPACK_PREMULTIPLY_ALPHA_WEBGL =
      const ContextParameter(
          WebGL.WebGL.UNPACK_PREMULTIPLY_ALPHA_WEBGL,
          'UNPACK_PREMULTIPLY_ALPHA_WEBGL');
  static const ContextParameter VENDOR =
      const ContextParameter(WebGL.WebGL.VENDOR, 'VENDOR');
  static const ContextParameter VERSION =
      const ContextParameter(WebGL.WebGL.VERSION, 'VERSION');
  static const ContextParameter VIEWPORT =
      const ContextParameter(WebGL.WebGL.VIEWPORT, 'VIEWPORT');
}

//WebGLRenderBuffers

//@reflector
class RenderBufferParameters extends WebGLEnum {
  const RenderBufferParameters(int index, String name) : super(index, name);
  static RenderBufferParameters getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(RenderBufferParameters, index)
          as RenderBufferParameters;

  static const RenderBufferParameters RENDERBUFFER_WIDTH =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_WIDTH, 'RENDERBUFFER_WIDTH');
  static const RenderBufferParameters RENDERBUFFER_HEIGHT =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_HEIGHT, 'RENDERBUFFER_HEIGHT');
  static const RenderBufferParameters RENDERBUFFER_INTERNAL_FORMAT =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_INTERNAL_FORMAT,
          'RENDERBUFFER_HEIGHT');
  static const RenderBufferParameters RENDERBUFFER_GREEN_SIZE =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_GREEN_SIZE,
          'RENDERBUFFER_GREEN_SIZE');
  static const RenderBufferParameters RENDERBUFFER_BLUE_SIZE =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_BLUE_SIZE,
          'RENDERBUFFER_BLUE_SIZE');
  static const RenderBufferParameters RENDERBUFFER_RED_SIZE =
      const RenderBufferParameters(WebGL.WebGL.RENDERBUFFER_RED_SIZE,
          'RENDERBUFFER_RED_SIZE');
  static const RenderBufferParameters RENDERBUFFER_ALPHA_SIZE =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_ALPHA_SIZE,
          'RENDERBUFFER_ALPHA_SIZE');
  static const RenderBufferParameters RENDERBUFFER_DEPTH_SIZE =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_DEPTH_SIZE,
          'RENDERBUFFER_DEPTH_SIZE');
  static const RenderBufferParameters RENDERBUFFER_STENCIL_SIZE =
      const RenderBufferParameters(
          WebGL.WebGL.RENDERBUFFER_STENCIL_SIZE,
          'RENDERBUFFER_STENCIL_SIZE');
}

//@reflector
class RenderBufferTarget extends WebGLEnum {
  const RenderBufferTarget(int index, String name) : super(index, name);
  static RenderBufferTarget getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(RenderBufferTarget, index)
          as RenderBufferTarget;

  static const RenderBufferTarget RENDERBUFFER = const RenderBufferTarget(
      WebGL.WebGL.RENDERBUFFER, 'RENDERBUFFER');
}

//@reflector
class RenderBufferInternalFormatType extends WebGLEnum {
  const RenderBufferInternalFormatType(int index, String name)
      : super(index, name);
  static RenderBufferInternalFormatType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(RenderBufferInternalFormatType, index)
          as RenderBufferInternalFormatType;

  static const RenderBufferInternalFormatType RGBA4 =
      const RenderBufferInternalFormatType(
          WebGL.WebGL.RGBA4, 'RGBA4');
  static const RenderBufferInternalFormatType RGB565 =
      const RenderBufferInternalFormatType(
          WebGL.WebGL.RGB565, 'RGB565');
  static const RenderBufferInternalFormatType RGB5_A1 =
      const RenderBufferInternalFormatType(
          WebGL.WebGL.RGB5_A1, 'RGB5_A1');
  static const RenderBufferInternalFormatType DEPTH_COMPONENT16 =
      const RenderBufferInternalFormatType(
          WebGL.WebGL.DEPTH_COMPONENT16, 'DEPTH_COMPONENT16');
  static const RenderBufferInternalFormatType STENCIL_INDEX8 =
      const RenderBufferInternalFormatType(
          WebGL.WebGL.STENCIL_INDEX8, 'STENCIL_INDEX8');
  static const RenderBufferInternalFormatType DEPTH_STENCIL =
      const RenderBufferInternalFormatType(
          WebGL.WebGL.DEPTH_STENCIL, 'DEPTH_STENCIL');
}

//WebGLFrameBuffers

//@reflector
class FrameBufferStatus extends WebGLEnum {
  const FrameBufferStatus(int index, String name) : super(index, name);
  static FrameBufferStatus getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FrameBufferStatus, index) as FrameBufferStatus;

  static const FrameBufferStatus FRAMEBUFFER_COMPLETE = const FrameBufferStatus(
      WebGL.WebGL.FRAMEBUFFER_COMPLETE, 'FRAMEBUFFER_COMPLETE');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_ATTACHMENT =
      const FrameBufferStatus(
          WebGL.WebGL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT,
          'FRAMEBUFFER_INCOMPLETE_ATTACHMENT');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT =
      const FrameBufferStatus(
          WebGL.WebGL.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT,
          'FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_DIMENSIONS =
      const FrameBufferStatus(
          WebGL.WebGL.FRAMEBUFFER_INCOMPLETE_DIMENSIONS,
          'FRAMEBUFFER_INCOMPLETE_DIMENSIONS');
  static const FrameBufferStatus FRAMEBUFFER_UNSUPPORTED =
      const FrameBufferStatus(WebGL.WebGL.FRAMEBUFFER_UNSUPPORTED,
          'FRAMEBUFFER_UNSUPPORTED');
}

//@reflector
class FrameBufferTarget extends WebGLEnum {
  const FrameBufferTarget(int index, String name) : super(index, name);
  static FrameBufferTarget getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FrameBufferTarget, index) as FrameBufferTarget;

  static const FrameBufferTarget FRAMEBUFFER = const FrameBufferTarget(
      WebGL.WebGL.FRAMEBUFFER, 'FRAMEBUFFER');
}

//@reflector
class FrameBufferAttachment extends WebGLEnum {
  const FrameBufferAttachment(int index, String name) : super(index, name);
  static FrameBufferAttachment getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FrameBufferAttachment, index)
          as FrameBufferAttachment;

  static const FrameBufferAttachment COLOR_ATTACHMENT0 =
      const FrameBufferAttachment(
          WebGL.WebGL.COLOR_ATTACHMENT0, 'COLOR_ATTACHMENT0');
  static const FrameBufferAttachment DEPTH_ATTACHMENT =
      const FrameBufferAttachment(
          WebGL.WebGL.DEPTH_ATTACHMENT, 'DEPTH_ATTACHMENT');
  static const FrameBufferAttachment STENCIL_ATTACHMENT =
      const FrameBufferAttachment(
          WebGL.WebGL.STENCIL_ATTACHMENT, 'STENCIL_ATTACHMENT');
}

//@reflector
class FrameBufferAttachmentType extends WebGLEnum {
  const FrameBufferAttachmentType(int index, String name) : super(index, name);
  static FrameBufferAttachmentType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FrameBufferAttachmentType, index)
          as FrameBufferAttachmentType;

  static const FrameBufferAttachmentType TEXTURE =
      const FrameBufferAttachmentType(
          WebGL.WebGL.TEXTURE, 'TEXTURE');
  static const FrameBufferAttachmentType RENDERBUFFER =
      const FrameBufferAttachmentType(
          WebGL.WebGL.RENDERBUFFER, 'RENDERBUFFER');
  static const FrameBufferAttachmentType NONE =
      const FrameBufferAttachmentType(WebGL.WebGL.NONE, 'NONE');
}

//@reflector
class FrameBufferAttachmentParameters extends WebGLEnum {
  const FrameBufferAttachmentParameters(int index, String name)
      : super(index, name);
  static FrameBufferAttachmentParameters getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(FrameBufferAttachmentParameters, index)
          as FrameBufferAttachmentParameters;

  static const FrameBufferAttachmentParameters
      FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE =
      const FrameBufferAttachmentParameters(
          WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,
          'FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE');
  static const FrameBufferAttachmentParameters
      FRAMEBUFFER_ATTACHMENT_OBJECT_NAME =
      const FrameBufferAttachmentParameters(
          WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,
          'FRAMEBUFFER_ATTACHMENT_OBJECT_NAME');
  static const FrameBufferAttachmentParameters
      FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL =
      const FrameBufferAttachmentParameters(
          WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL,
          'FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL');
  static const FrameBufferAttachmentParameters
      FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE =
      const FrameBufferAttachmentParameters(
          WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE,
          'FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE');
}

//@reflector
class TextureAttachmentTarget extends WebGLEnum {
  const TextureAttachmentTarget(int index, String name) : super(index, name);
  static TextureAttachmentTarget getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureAttachmentTarget, index)
          as TextureAttachmentTarget;

  static const TextureAttachmentTarget TEXTURE_2D =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_2D, 'TEXTURE_2D');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_X =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_CUBE_MAP_POSITIVE_X,
          'TEXTURE_CUBE_MAP_POSITIVE_X');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_X =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_CUBE_MAP_NEGATIVE_X,
          'TEXTURE_CUBE_MAP_NEGATIVE_X');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_Y =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_CUBE_MAP_POSITIVE_Y,
          'TEXTURE_CUBE_MAP_POSITIVE_Y');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_Y =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_CUBE_MAP_NEGATIVE_Y,
          'TEXTURE_CUBE_MAP_NEGATIVE_Y');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_Z =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_CUBE_MAP_POSITIVE_Z,
          'TEXTURE_CUBE_MAP_POSITIVE_Z');
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_Z =
      const TextureAttachmentTarget(
          WebGL.WebGL.TEXTURE_CUBE_MAP_NEGATIVE_Z,
          'TEXTURE_CUBE_MAP_NEGATIVE_Z');

  /// need to iterate instead of : gl.TEXTURE_CUBE_MAP_POSITIVE_X + i
  static List<TextureAttachmentTarget> TEXTURE_CUBE_MAPS = [
    TEXTURE_CUBE_MAP_POSITIVE_X,
    TEXTURE_CUBE_MAP_NEGATIVE_X,
    TEXTURE_CUBE_MAP_POSITIVE_Y,
    TEXTURE_CUBE_MAP_NEGATIVE_Y,
    TEXTURE_CUBE_MAP_POSITIVE_Z,
    TEXTURE_CUBE_MAP_NEGATIVE_Z
  ];
}

//WebGLBuffers

//@reflector
class BufferType extends WebGLEnum {
  const BufferType(int index, String name) : super(index, name);
  static BufferType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(BufferType, index) as BufferType;

  static const BufferType ARRAY_BUFFER =
      const BufferType(WebGL.WebGL.ARRAY_BUFFER, 'ARRAY_BUFFER');
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(
      WebGL.WebGL.ELEMENT_ARRAY_BUFFER, 'ELEMENT_ARRAY_BUFFER');
}

//@reflector
class BufferUsageType extends WebGLEnum {
  const BufferUsageType(int index, String name) : super(index, name);
  static BufferUsageType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(BufferUsageType, index) as BufferUsageType;

  static const BufferUsageType STATIC_DRAW =
      const BufferUsageType(WebGL.WebGL.STATIC_DRAW, 'STATIC_DRAW');
  static const BufferUsageType DYNAMIC_DRAW = const BufferUsageType(
      WebGL.WebGL.DYNAMIC_DRAW, 'DYNAMIC_DRAW');
  static const BufferUsageType STREAM_DRAW =
      const BufferUsageType(WebGL.WebGL.STREAM_DRAW, 'STREAM_DRAW');
}

//@reflector
class BufferParameters extends WebGLEnum {
  const BufferParameters(int index, String name) : super(index, name);
  static BufferParameters getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(BufferParameters, index) as BufferParameters;

  static const BufferParameters BUFFER_SIZE =
      const BufferParameters(WebGL.WebGL.BUFFER_SIZE, 'BUFFER_SIZE');
  static const BufferParameters BUFFER_USAGE = const BufferParameters(
      WebGL.WebGL.BUFFER_USAGE, 'BUFFER_USAGE');
}

//WebGLPrograms

//@reflector
class ProgramParameterGlEnum extends WebGLEnum {
  const ProgramParameterGlEnum(int index, String name) : super(index, name);
  static ProgramParameterGlEnum getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ProgramParameterGlEnum, index)
          as ProgramParameterGlEnum;

  static const ProgramParameterGlEnum DELETE_STATUS =
      const ProgramParameterGlEnum(
          WebGL.WebGL.DELETE_STATUS, 'DELETE_STATUS');
  static const ProgramParameterGlEnum LINK_STATUS =
      const ProgramParameterGlEnum(
          WebGL.WebGL.LINK_STATUS, 'LINK_STATUS');
  static const ProgramParameterGlEnum VALIDATE_STATUS =
      const ProgramParameterGlEnum(
          WebGL.WebGL.VALIDATE_STATUS, 'VALIDATE_STATUS');
  static const ProgramParameterGlEnum ATTACHED_SHADERS =
      const ProgramParameterGlEnum(
          WebGL.WebGL.ATTACHED_SHADERS, 'ATTACHED_SHADERS');
  static const ProgramParameterGlEnum ACTIVE_ATTRIBUTES =
      const ProgramParameterGlEnum(
          WebGL.WebGL.ACTIVE_ATTRIBUTES, 'ACTIVE_ATTRIBUTES');
  static const ProgramParameterGlEnum ACTIVE_UNIFORMS =
      const ProgramParameterGlEnum(
          WebGL.WebGL.ACTIVE_UNIFORMS, 'ACTIVE_UNIFORMS');
}

//@reflector
class VertexAttribArrayType extends WebGLEnum {
  const VertexAttribArrayType(int index, String name) : super(index, name);
  static VertexAttribArrayType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(VertexAttribArrayType, index)
          as VertexAttribArrayType;

  static const VertexAttribArrayType BYTE =
      const VertexAttribArrayType(WebGL.WebGL.BYTE, 'BYTE');
  static const VertexAttribArrayType UNSIGNED_BYTE =
      const VertexAttribArrayType(
          WebGL.WebGL.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const VertexAttribArrayType SHORT =
      const VertexAttribArrayType(WebGL.WebGL.SHORT, 'SHORT');
  static const VertexAttribArrayType UNSIGNED_SHORT =
      const VertexAttribArrayType(
          WebGL.WebGL.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static const VertexAttribArrayType FLOAT =
      const VertexAttribArrayType(WebGL.WebGL.FLOAT, 'FLOAT');
}

//WebGLTextures

//@reflector
class TextureTarget extends WebGLEnum {
  const TextureTarget(int index, String name) : super(index, name);
  static TextureTarget getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureTarget, index) as TextureTarget;

  static const TextureTarget TEXTURE_2D =
      const TextureTarget(WebGL.WebGL.TEXTURE_2D, 'TEXTURE_2D');
  static const TextureTarget TEXTURE_CUBE_MAP = const TextureTarget(
      WebGL.WebGL.TEXTURE_CUBE_MAP, 'TEXTURE_CUBE_MAP');
}

//@reflector
class TextureUnit extends WebGLEnum {
  const TextureUnit(int index, String name) : super(index, name);
  static TextureUnit getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureUnit, index) as TextureUnit;

  static const TextureUnit TEXTURE0 =
      const TextureUnit(WebGL.WebGL.TEXTURE0, 'TEXTURE0');
  static const TextureUnit TEXTURE1 =
      const TextureUnit(WebGL.WebGL.TEXTURE1, 'TEXTURE1');
  static const TextureUnit TEXTURE2 =
      const TextureUnit(WebGL.WebGL.TEXTURE2, 'TEXTURE2');
  static const TextureUnit TEXTURE3 =
      const TextureUnit(WebGL.WebGL.TEXTURE3, 'TEXTURE3');
  static const TextureUnit TEXTURE4 =
      const TextureUnit(WebGL.WebGL.TEXTURE4, 'TEXTURE4');
  static const TextureUnit TEXTURE5 =
      const TextureUnit(WebGL.WebGL.TEXTURE5, 'TEXTURE5');
  static const TextureUnit TEXTURE6 =
      const TextureUnit(WebGL.WebGL.TEXTURE6, 'TEXTURE6');
  static const TextureUnit TEXTURE7 =
      const TextureUnit(WebGL.WebGL.TEXTURE7, 'TEXTURE7');
  static const TextureUnit TEXTURE8 =
      const TextureUnit(WebGL.WebGL.TEXTURE8, 'TEXTURE8');
  static const TextureUnit TEXTURE9 =
      const TextureUnit(WebGL.WebGL.TEXTURE9, 'TEXTURE9');
  static const TextureUnit TEXTURE10 =
      const TextureUnit(WebGL.WebGL.TEXTURE10, 'TEXTURE10');
  static const TextureUnit TEXTURE11 =
      const TextureUnit(WebGL.WebGL.TEXTURE11, 'TEXTURE11');
  static const TextureUnit TEXTURE12 =
      const TextureUnit(WebGL.WebGL.TEXTURE12, 'TEXTURE12');
  static const TextureUnit TEXTURE13 =
      const TextureUnit(WebGL.WebGL.TEXTURE13, 'TEXTURE13');
  static const TextureUnit TEXTURE14 =
      const TextureUnit(WebGL.WebGL.TEXTURE14, 'TEXTURE14');
  static const TextureUnit TEXTURE15 =
      const TextureUnit(WebGL.WebGL.TEXTURE15, 'TEXTURE15');
  static const TextureUnit TEXTURE16 =
      const TextureUnit(WebGL.WebGL.TEXTURE16, 'TEXTURE16');
  static const TextureUnit TEXTURE17 =
      const TextureUnit(WebGL.WebGL.TEXTURE17, 'TEXTURE17');
  static const TextureUnit TEXTURE18 =
      const TextureUnit(WebGL.WebGL.TEXTURE18, 'TEXTURE18');
  static const TextureUnit TEXTURE19 =
      const TextureUnit(WebGL.WebGL.TEXTURE19, 'TEXTURE19');
  static const TextureUnit TEXTURE20 =
      const TextureUnit(WebGL.WebGL.TEXTURE20, 'TEXTURE20');
  static const TextureUnit TEXTURE21 =
      const TextureUnit(WebGL.WebGL.TEXTURE21, 'TEXTURE21');
  static const TextureUnit TEXTURE22 =
      const TextureUnit(WebGL.WebGL.TEXTURE22, 'TEXTURE22');
  static const TextureUnit TEXTURE23 =
      const TextureUnit(WebGL.WebGL.TEXTURE23, 'TEXTURE23');
  static const TextureUnit TEXTURE24 =
      const TextureUnit(WebGL.WebGL.TEXTURE24, 'TEXTURE24');
  static const TextureUnit TEXTURE25 =
      const TextureUnit(WebGL.WebGL.TEXTURE25, 'TEXTURE25');
  static const TextureUnit TEXTURE26 =
      const TextureUnit(WebGL.WebGL.TEXTURE26, 'TEXTURE26');
  static const TextureUnit TEXTURE27 =
      const TextureUnit(WebGL.WebGL.TEXTURE27, 'TEXTURE27');
  static const TextureUnit TEXTURE28 =
      const TextureUnit(WebGL.WebGL.TEXTURE28, 'TEXTURE28');
  static const TextureUnit TEXTURE29 =
      const TextureUnit(WebGL.WebGL.TEXTURE29, 'TEXTURE29');
  static const TextureUnit TEXTURE30 =
      const TextureUnit(WebGL.WebGL.TEXTURE30, 'TEXTURE30');
  static const TextureUnit TEXTURE31 =
      const TextureUnit(WebGL.WebGL.TEXTURE31, 'TEXTURE31');
}

//@reflector
class TextureParameter extends WebGLEnum {
  const TextureParameter(int index, String name) : super(index, name);
  static TextureParameter getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureParameter, index) as TextureParameter;

  static const TextureParameter TEXTURE_MAG_FILTER = const TextureParameter(
      WebGL.WebGL.TEXTURE_MAG_FILTER, 'TEXTURE_MAG_FILTER');
  static const TextureParameter TEXTURE_MIN_FILTER = const TextureParameter(
      WebGL.WebGL.TEXTURE_MIN_FILTER, 'TEXTURE_MIN_FILTER');
  static const TextureParameter TEXTURE_WRAP_S = const TextureParameter(
      WebGL.WebGL.TEXTURE_WRAP_S, 'TEXTURE_WRAP_S');
  static const TextureParameter TEXTURE_WRAP_T = const TextureParameter(
      WebGL.WebGL.TEXTURE_WRAP_T, 'TEXTURE_WRAP_T');
}

//@reflector
abstract class TextureSetParameterType extends WebGLEnum {
  const TextureSetParameterType(int index, String name) : super(index, name);
}

//@reflector
class TextureFilterType extends TextureSetParameterType {
  const TextureFilterType(int index, String name) : super(index, name);

  static TextureFilterType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureFilterType, index) as TextureFilterType;

  static const TextureFilterType LINEAR =
      const TextureFilterType(WebGL.WebGL.LINEAR, 'LINEAR');
  static const TextureFilterType NEAREST =
      const TextureFilterType(WebGL.WebGL.NEAREST, 'NEAREST');
  static const TextureFilterType NEAREST_MIPMAP_NEAREST =
      const TextureFilterType(WebGL.WebGL.NEAREST_MIPMAP_NEAREST,
          'NEAREST_MIPMAP_NEAREST');
  static const TextureFilterType LINEAR_MIPMAP_NEAREST =
      const TextureFilterType(WebGL.WebGL.LINEAR_MIPMAP_NEAREST,
          'LINEAR_MIPMAP_NEAREST');
  static const TextureFilterType NEAREST_MIPMAP_LINEAR =
      const TextureFilterType(WebGL.WebGL.NEAREST_MIPMAP_LINEAR,
          'NEAREST_MIPMAP_LINEAR');
  static const TextureFilterType LINEAR_MIPMAP_LINEAR = const TextureFilterType(
      WebGL.WebGL.LINEAR_MIPMAP_LINEAR, 'LINEAR_MIPMAP_LINEAR');
}

//@reflector
class TextureMagnificationFilterType extends TextureFilterType {
  const TextureMagnificationFilterType(int index, String name)
      : super(index, name);
  static TextureFilterType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureMagnificationFilterType, index)
          as TextureMagnificationFilterType;

  static const TextureMagnificationFilterType LINEAR =
      const TextureMagnificationFilterType(
          WebGL.WebGL.LINEAR, 'LINEAR');
  static const TextureMagnificationFilterType NEAREST =
      const TextureMagnificationFilterType(
          WebGL.WebGL.NEAREST, 'NEAREST');
}

//@reflector
class TextureMinificationFilterType extends TextureFilterType {
  const TextureMinificationFilterType(int index, String name)
      : super(index, name);
  static TextureFilterType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureMinificationFilterType, index)
          as TextureMinificationFilterType;

  static const TextureMinificationFilterType LINEAR =
      const TextureMinificationFilterType(
          WebGL.WebGL.LINEAR, 'LINEAR');
  static const TextureMinificationFilterType NEAREST =
      const TextureMinificationFilterType(
          WebGL.WebGL.NEAREST, 'NEAREST');
  static const TextureMinificationFilterType NEAREST_MIPMAP_NEAREST =
      const TextureMinificationFilterType(
          WebGL.WebGL.NEAREST_MIPMAP_NEAREST,
          'NEAREST_MIPMAP_NEAREST');
  static const TextureMinificationFilterType LINEAR_MIPMAP_NEAREST =
      const TextureMinificationFilterType(
          WebGL.WebGL.LINEAR_MIPMAP_NEAREST,
          'LINEAR_MIPMAP_NEAREST');
  static const TextureMinificationFilterType NEAREST_MIPMAP_LINEAR =
      const TextureMinificationFilterType(
          WebGL.WebGL.NEAREST_MIPMAP_LINEAR,
          'NEAREST_MIPMAP_LINEAR');
  static const TextureMinificationFilterType LINEAR_MIPMAP_LINEAR =
      const TextureMinificationFilterType(
          WebGL.WebGL.LINEAR_MIPMAP_LINEAR, 'LINEAR_MIPMAP_LINEAR');
}

//@reflector
class TextureWrapType extends TextureSetParameterType {
  const TextureWrapType(int index, String name) : super(index, name);
  static TextureWrapType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureWrapType, index) as TextureWrapType;

  static const TextureWrapType REPEAT =
      const TextureWrapType(WebGL.WebGL.REPEAT, 'REPEAT');
  static const TextureWrapType CLAMP_TO_EDGE = const TextureWrapType(
      WebGL.WebGL.CLAMP_TO_EDGE, 'CLAMP_TO_EDGE');
  static const TextureWrapType MIRRORED_REPEAT = const TextureWrapType(
      WebGL.WebGL.MIRRORED_REPEAT, 'MIRRORED_REPEAT');
}

//@reflector
class TextureInternalFormat extends WebGLEnum {
  const TextureInternalFormat(int index, String name) : super(index, name);
  static TextureInternalFormat getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TextureInternalFormat, index)
          as TextureInternalFormat;

  static const TextureInternalFormat ALPHA =
      const TextureInternalFormat(WebGL.WebGL.ALPHA, 'ALPHA');
  static const TextureInternalFormat RGB =
      const TextureInternalFormat(WebGL.WebGL.RGB, 'RGB');
  static const TextureInternalFormat RGBA =
      const TextureInternalFormat(WebGL.WebGL.RGBA, 'RGBA');
  static const TextureInternalFormat LUMINANCE = const TextureInternalFormat(
      WebGL.WebGL.LUMINANCE, 'LUMINANCE');
  static const TextureInternalFormat LUMINANCE_ALPHA =
      const TextureInternalFormat(
          WebGL.WebGL.LUMINANCE_ALPHA, 'LUMINANCE_ALPHA');
}

//@reflector
class TexelDataType extends WebGLEnum {
  const TexelDataType(int index, String name) : super(index, name);
  static TexelDataType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(TexelDataType, index) as TexelDataType;

  static const TexelDataType UNSIGNED_BYTE = const TexelDataType(
      WebGL.WebGL.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const TexelDataType UNSIGNED_SHORT_5_6_5 = const TexelDataType(
      WebGL.WebGL.UNSIGNED_SHORT_5_6_5, 'UNSIGNED_SHORT_5_6_5');
  static const TexelDataType UNSIGNED_SHORT_4_4_4_4 = const TexelDataType(
      WebGL.WebGL.UNSIGNED_SHORT_4_4_4_4, 'UNSIGNED_SHORT_4_4_4_4');
  static const TexelDataType UNSIGNED_SHORT_5_5_5_1 = const TexelDataType(
      WebGL.WebGL.UNSIGNED_SHORT_5_5_5_1, 'UNSIGNED_SHORT_5_5_5_1');
}

//WebGLShaders

//@reflector
class ShaderVariableType extends WebGLEnum {
  const ShaderVariableType(int index, String name) : super(index, name);
  static ShaderVariableType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ShaderVariableType, index)
          as ShaderVariableType;

  static ShaderVariableType getByComponentAndType(String component, String type) =>
      [
        FLOAT_VEC2,
        FLOAT_VEC3,
        FLOAT_VEC4,
        INT_VEC2,
        INT_VEC3,
        INT_VEC4,
        BOOL,
        BOOL_VEC2,
        BOOL_VEC3,
        BOOL_VEC4,
        FLOAT_MAT2,
        FLOAT_MAT3,
        FLOAT_MAT4,
        SAMPLER_2D,
        SAMPLER_CUBE,
        BYTE,
        UNSIGNED_BYTE,
        SHORT,
        UNSIGNED_SHORT,
        INT,
        UNSIGNED_INT,
        UNSIGNED_INT,
        FLOAT
      ].firstWhere((s)=>s.name.contains(component) && s.name.contains(type), orElse:()=>null);

  static const ShaderVariableType FLOAT_VEC2 =
      const ShaderVariableType(WebGL.WebGL.FLOAT_VEC2, 'FLOAT_VEC2');
  static const ShaderVariableType FLOAT_VEC3 =
      const ShaderVariableType(WebGL.WebGL.FLOAT_VEC3, 'FLOAT_VEC3');
  static const ShaderVariableType FLOAT_VEC4 =
      const ShaderVariableType(WebGL.WebGL.FLOAT_VEC4, 'FLOAT_VEC4');
  static const ShaderVariableType INT_VEC2 =
      const ShaderVariableType(WebGL.WebGL.INT_VEC2, 'INT_VEC2');
  static const ShaderVariableType INT_VEC3 =
      const ShaderVariableType(WebGL.WebGL.INT_VEC3, 'INT_VEC3');
  static const ShaderVariableType INT_VEC4 =
      const ShaderVariableType(WebGL.WebGL.INT_VEC4, 'INT_VEC4');
  static const ShaderVariableType BOOL =
      const ShaderVariableType(WebGL.WebGL.BOOL, 'BOOL');
  static const ShaderVariableType BOOL_VEC2 =
      const ShaderVariableType(WebGL.WebGL.BOOL_VEC2, 'BOOL_VEC2');
  static const ShaderVariableType BOOL_VEC3 =
      const ShaderVariableType(WebGL.WebGL.BOOL_VEC3, 'BOOL_VEC3');
  static const ShaderVariableType BOOL_VEC4 =
      const ShaderVariableType(WebGL.WebGL.BOOL_VEC4, 'BOOL_VEC4');
  static const ShaderVariableType FLOAT_MAT2 =
      const ShaderVariableType(WebGL.WebGL.FLOAT_MAT2, 'FLOAT_MAT2');
  static const ShaderVariableType FLOAT_MAT3 =
      const ShaderVariableType(WebGL.WebGL.FLOAT_MAT3, 'FLOAT_MAT3');
  static const ShaderVariableType FLOAT_MAT4 =
      const ShaderVariableType(WebGL.WebGL.FLOAT_MAT4, 'FLOAT_MAT4');
  static const ShaderVariableType SAMPLER_2D =
      const ShaderVariableType(WebGL.WebGL.SAMPLER_2D, 'SAMPLER_2D');
  static const ShaderVariableType SAMPLER_CUBE = const ShaderVariableType(
      WebGL.WebGL.SAMPLER_CUBE, 'SAMPLER_CUBE');
  static const ShaderVariableType BYTE =
      const ShaderVariableType(WebGL.WebGL.BYTE, 'BYTE');
  static const ShaderVariableType UNSIGNED_BYTE = const ShaderVariableType(
      WebGL.WebGL.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const ShaderVariableType SHORT =
      const ShaderVariableType(WebGL.WebGL.SHORT, 'SHORT');
  static const ShaderVariableType UNSIGNED_SHORT = const ShaderVariableType(
      WebGL.WebGL.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static const ShaderVariableType INT =
      const ShaderVariableType(WebGL.WebGL.INT, 'INT');
  static const ShaderVariableType UNSIGNED_INT = const ShaderVariableType(
      WebGL.WebGL.UNSIGNED_INT, 'UNSIGNED_INT');
  static const ShaderVariableType FLOAT =
      const ShaderVariableType(WebGL.WebGL.FLOAT, 'FLOAT');
}

//@reflector
class PrecisionType extends WebGLEnum {
  const PrecisionType(int index, String name) : super(index, name);
  static PrecisionType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(PrecisionType, index) as PrecisionType;

  static const PrecisionType LOW_INT =
      const PrecisionType(WebGL.WebGL.LOW_INT, 'LOW_INT');
  static const PrecisionType LOW_FLOAT =
      const PrecisionType(WebGL.WebGL.LOW_FLOAT, 'LOW_FLOAT');
  static const PrecisionType MEDIUM_INT =
      const PrecisionType(WebGL.WebGL.MEDIUM_INT, 'MEDIUM_INT');
  static const PrecisionType MEDIUM_FLOAT =
      const PrecisionType(WebGL.WebGL.MEDIUM_FLOAT, 'MEDIUM_FLOAT');
  static const PrecisionType HIGH_INT =
      const PrecisionType(WebGL.WebGL.HIGH_INT, 'HIGH_INT');
  static const PrecisionType HIGH_FLOAT =
      const PrecisionType(WebGL.WebGL.HIGH_FLOAT, 'HIGH_FLOAT');
}

//@reflector
class ShaderType extends WebGLEnum {
  const ShaderType(int index, String name) : super(index, name);
  static ShaderType getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ShaderType, index) as ShaderType;

  static const ShaderType FRAGMENT_SHADER = const ShaderType(
      WebGL.WebGL.FRAGMENT_SHADER, 'FRAGMENT_SHADER');
  static const ShaderType VERTEX_SHADER =
      const ShaderType(WebGL.WebGL.VERTEX_SHADER, 'VERTEX_SHADER');
}

//@reflector
class ShaderParameters extends WebGLEnum {
  const ShaderParameters(int index, String name) : super(index, name);
  static ShaderParameters getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(ShaderParameters, index) as ShaderParameters;

  static const ShaderParameters DELETE_STATUS = const ShaderParameters(
      WebGL.WebGL.DELETE_STATUS, 'DELETE_STATUS');
  static const ShaderParameters COMPILE_STATUS = const ShaderParameters(
      WebGL.WebGL.COMPILE_STATUS, 'COMPILE_STATUS');
  static const ShaderParameters SHADER_TYPE =
      const ShaderParameters(WebGL.WebGL.SHADER_TYPE, 'SHADER_TYPE');
}

//@reflector
class VertexAttribGlEnum extends WebGLEnum {
  const VertexAttribGlEnum(int index, String name) : super(index, name);
  static VertexAttribGlEnum getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(VertexAttribGlEnum, index)
          as VertexAttribGlEnum;

  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING =
      const VertexAttribGlEnum(
          WebGL.WebGL.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,
          'VERTEX_ATTRIB_ARRAY_BUFFER_BINDING');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_ENABLED =
      const VertexAttribGlEnum(
          WebGL.WebGL.VERTEX_ATTRIB_ARRAY_ENABLED,
          'VERTEX_ATTRIB_ARRAY_ENABLED');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_SIZE =
      const VertexAttribGlEnum(WebGL.WebGL.VERTEX_ATTRIB_ARRAY_SIZE,
          'VERTEX_ATTRIB_ARRAY_SIZE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_STRIDE =
      const VertexAttribGlEnum(
          WebGL.WebGL.VERTEX_ATTRIB_ARRAY_STRIDE,
          'VERTEX_ATTRIB_ARRAY_STRIDE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_TYPE =
      const VertexAttribGlEnum(WebGL.WebGL.VERTEX_ATTRIB_ARRAY_TYPE,
          'VERTEX_ATTRIB_ARRAY_TYPE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_NORMALIZED =
      const VertexAttribGlEnum(
          WebGL.WebGL.VERTEX_ATTRIB_ARRAY_NORMALIZED,
          'VERTEX_ATTRIB_ARRAY_NORMALIZED');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_POINTER =
      const VertexAttribGlEnum(
          WebGL.WebGL.VERTEX_ATTRIB_ARRAY_POINTER,
          'VERTEX_ATTRIB_ARRAY_POINTER');
  static const VertexAttribGlEnum CURRENT_VERTEX_ATTRIB =
      const VertexAttribGlEnum(WebGL.WebGL.CURRENT_VERTEX_ATTRIB,
          'CURRENT_VERTEX_ATTRIB');
}
