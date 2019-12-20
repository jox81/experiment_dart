import 'dart:web_gl' as WebGL;
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;

//WebGLRenderingContext

//@reflector
class EnableCapabilityType {
  static const int BLEND = WebGL.WebGL.BLEND;
  static const int CULL_FACE = WebGL.WebGL.CULL_FACE;
  static const int DEPTH_TEST = WebGL.WebGL.DEPTH_TEST;
  static const int DITHER = WebGL.WebGL.DITHER;
  static const int POLYGON_OFFSET_FILL = WebGL.WebGL.POLYGON_OFFSET_FILL;
  static const int SAMPLE_ALPHA_TO_COVERAGE = WebGL.WebGL.SAMPLE_ALPHA_TO_COVERAGE;
  static const int SAMPLE_COVERAGE = WebGL.WebGL.SAMPLE_COVERAGE;
  static const int SCISSOR_TEST = WebGL.WebGL.SCISSOR_TEST;
  static const int STENCIL_TEST = WebGL.WebGL.STENCIL_TEST;
}

//@reflector
class FacingType {
  static const int FRONT = WebGL.WebGL.FRONT;
  static const int BACK = WebGL.WebGL.BACK;
  static const int FRONT_AND_BACK = WebGL.WebGL.FRONT_AND_BACK;
}

//@reflector
class ClearBufferMask {
  static const int DEPTH_BUFFER_BIT = WebGL.WebGL.DEPTH_BUFFER_BIT;
  static const int STENCIL_BUFFER_BIT = WebGL.WebGL.STENCIL_BUFFER_BIT;
  static const int COLOR_BUFFER_BIT = WebGL.WebGL.COLOR_BUFFER_BIT;
}

//@reflector
class FrontFaceDirection {
  static const int CW = WebGL.WebGL.CW;
  static const int CCW = WebGL.WebGL.CCW;
}

//@reflector
class PixelStorgeType {
  static const int PACK_ALIGNMENT = WebGL.WebGL.PACK_ALIGNMENT;
  static const int UNPACK_ALIGNMENT = WebGL.WebGL.UNPACK_ALIGNMENT;
  static const int UNPACK_FLIP_Y_WEBGL = WebGL.WebGL.UNPACK_FLIP_Y_WEBGL;
  static const int UNPACK_PREMULTIPLY_ALPHA_WEBGL = WebGL.WebGL.UNPACK_PREMULTIPLY_ALPHA_WEBGL;
  static const int UNPACK_COLORSPACE_CONVERSION_WEBGL = WebGL.WebGL.UNPACK_COLORSPACE_CONVERSION_WEBGL;
}

//@reflector
class DrawMode {
  static const int POINTS = WebGL.WebGL.POINTS;
  static const int LINE_STRIP = WebGL.WebGL.LINE_STRIP;
  static const int LINE_LOOP = WebGL.WebGL.LINE_LOOP;
  static const int LINES = WebGL.WebGL.LINES;
  static const int TRIANGLE_STRIP = WebGL.WebGL.TRIANGLE_STRIP;
  static const int TRIANGLE_FAN = WebGL.WebGL.TRIANGLE_FAN;
  static const int TRIANGLES = WebGL.WebGL.TRIANGLES;
}

//@reflector
class BufferElementType {
  static const int UNSIGNED_BYTE = WebGL.WebGL.UNSIGNED_BYTE;
  static const int UNSIGNED_SHORT = WebGL.WebGL.UNSIGNED_SHORT;
}

//@reflector
class ReadPixelDataFormat {
  static const int ALPHA = WebGL.WebGL.ALPHA;
  static const int RGB = WebGL.WebGL.RGB;
  static const int RGBA = WebGL.WebGL.RGBA;
}

//@reflector
class ReadPixelDataType {
  static const int UNSIGNED_BYTE = WebGL.WebGL.UNSIGNED_BYTE;
  static const int UNSIGNED_SHORT_5_6_5 = WebGL.WebGL.UNSIGNED_SHORT_5_6_5;
  static const int UNSIGNED_SHORT_4_4_4_4 = WebGL.WebGL.UNSIGNED_SHORT_4_4_4_4;
  static const int UNSIGNED_SHORT_5_5_5_1 = WebGL.WebGL.UNSIGNED_SHORT_5_5_5_1;
  static const int FLOAT = WebGL.WebGL.FLOAT;
}

//@reflector
class ComparisonFunction {
  static const int NEVER = WebGL.WebGL.NEVER;
  static const int LESS = WebGL.WebGL.LESS;
  static const int EQUAL = WebGL.WebGL.EQUAL;
  static const int LEQUAL = WebGL.WebGL.LEQUAL;
  static const int GREATER = WebGL.WebGL.GREATER;
  static const int NOTEQUAL = WebGL.WebGL.NOTEQUAL;
  static const int GEQUAL = WebGL.WebGL.GEQUAL;
  static const int ALWAYS = WebGL.WebGL.ALWAYS;
}

//@reflector
class ErrorCode {
  static const int NO_ERROR = WebGL.WebGL.NO_ERROR;
  static const int INVALID_ENUM = WebGL.WebGL.INVALID_ENUM;
  static const int INVALID_VALUE = WebGL.WebGL.INVALID_VALUE;
  static const int INVALID_OPERATION = WebGL.WebGL.INVALID_OPERATION;
  static const int INVALID_FRAMEBUFFER_OPERATION = WebGL.WebGL.INVALID_FRAMEBUFFER_OPERATION;
  static const int OUT_OF_MEMORY = WebGL.WebGL.OUT_OF_MEMORY;
  static const int CONTEXT_LOST_WEBGL = WebGL.WebGL.CONTEXT_LOST_WEBGL;
}

//@reflector
class HintMode {
  static const int FASTEST = WebGL.WebGL.FASTEST;
  static const int NICEST = WebGL.WebGL.NICEST;
  static const int DONT_CARE = WebGL.WebGL.DONT_CARE;
}

//@reflector
class StencilOpMode {
  static const int ZERO = WebGL.WebGL.ZERO;
  static const int KEEP = WebGL.WebGL.KEEP;
  static const int REPLACE = WebGL.WebGL.REPLACE;
  static const int INVERT = WebGL.WebGL.INVERT;
  static const int INCR = WebGL.WebGL.INCR;
  static const int INCR_WRAP = WebGL.WebGL.INCR_WRAP;
  static const int DECR = WebGL.WebGL.DECR;
  static const int DECR_WRAP = WebGL.WebGL.DECR_WRAP;
}

//@reflector
class BlendFactorMode {
  static const int ZERO = WebGL.WebGL.ZERO;
  static const int ONE = WebGL.WebGL.ONE;
  static const int SRC_COLOR = WebGL.WebGL.SRC_COLOR;
  static const int SRC_ALPHA = WebGL.WebGL.SRC_ALPHA;
  static const int SRC_ALPHA_SATURATE = WebGL.WebGL.SRC_ALPHA_SATURATE;
  static const int DST_COLOR = WebGL.WebGL.DST_COLOR;
  static const int DST_ALPHA = WebGL.WebGL.DST_ALPHA;
  static const int CONSTANT_COLOR = WebGL.WebGL.CONSTANT_COLOR;
  static const int CONSTANT_ALPHA = WebGL.WebGL.CONSTANT_ALPHA;
  static const int ONE_MINUS_SRC_COLOR = WebGL.WebGL.ONE_MINUS_SRC_COLOR;
  static const int ONE_MINUS_SRC_ALPHA = WebGL.WebGL.ONE_MINUS_SRC_ALPHA;
  static const int ONE_MINUS_DST_COLOR = WebGL.WebGL.ONE_MINUS_DST_COLOR;
  static const int ONE_MINUS_DST_ALPHA = WebGL.WebGL.ONE_MINUS_DST_ALPHA;
  static const int ONE_MINUS_CONSTANT_COLOR = WebGL.WebGL.ONE_MINUS_CONSTANT_COLOR;
  static const int ONE_MINUS_CONSTANT_ALPHA = WebGL.WebGL.ONE_MINUS_CONSTANT_ALPHA;
}

//@reflector
class BlendFunctionMode {
  static const int FUNC_ADD = WebGL.WebGL.FUNC_ADD;
  static const int FUNC_SUBTRACT = WebGL.WebGL.FUNC_SUBTRACT;
  static const int FUNC_REVERSE_SUBTRACT = WebGL.WebGL.FUNC_REVERSE_SUBTRACT;
}

//@reflector
class ContextParameter {
  static const int ACTIVE_TEXTURE = WebGL.WebGL.ACTIVE_TEXTURE;
  static const int ALIASED_LINE_WIDTH_RANGE = WebGL.WebGL.ALIASED_LINE_WIDTH_RANGE;
  static const int ALIASED_POINT_SIZE_RANGE = WebGL.WebGL.ALIASED_POINT_SIZE_RANGE;
  static const int ALPHA_BITS = WebGL.WebGL.ALPHA_BITS;
  static const int ARRAY_BUFFER_BINDING = WebGL.WebGL.ARRAY_BUFFER_BINDING;
  static const int BLEND = WebGL.WebGL.BLEND;
  static const int BLEND_COLOR = WebGL.WebGL.BLEND_COLOR;
  static const int BLEND_DST_ALPHA = WebGL.WebGL.BLEND_DST_ALPHA;
  static const int BLEND_DST_RGB = WebGL.WebGL.BLEND_DST_RGB;
  static const int BLEND_EQUATION = WebGL.WebGL.BLEND_EQUATION;
  static const int BLEND_EQUATION_ALPHA = WebGL.WebGL.BLEND_EQUATION_ALPHA;
  static const int BLEND_EQUATION_RGB = WebGL.WebGL.BLEND_EQUATION_RGB;
  static const int BLEND_SRC_ALPHA = WebGL.WebGL.BLEND_SRC_ALPHA;
  static const int BLEND_SRC_RGB = WebGL.WebGL.BLEND_SRC_RGB;
  static const int BLUE_BITS = WebGL.WebGL.BLUE_BITS;
  static const int COLOR_CLEAR_VALUE = WebGL.WebGL.COLOR_CLEAR_VALUE;
  static const int COLOR_WRITEMASK = WebGL.WebGL.COLOR_WRITEMASK;
  static const int COMPRESSED_TEXTURE_FORMATS = WebGL.WebGL.COMPRESSED_TEXTURE_FORMATS;
  static const int CULL_FACE_MODE = WebGL.WebGL.CULL_FACE_MODE;
  static const int CURRENT_PROGRAM = WebGL.WebGL.CURRENT_PROGRAM;
  static const int DEPTH_BITS = WebGL.WebGL.DEPTH_BITS;
  static const int DEPTH_CLEAR_VALUE = WebGL.WebGL.DEPTH_CLEAR_VALUE;
  static const int DEPTH_FUNC = WebGL.WebGL.DEPTH_FUNC;
  static const int DEPTH_RANGE = WebGL.WebGL.DEPTH_RANGE;
  static const int DEPTH_TEST = WebGL.WebGL.DEPTH_TEST;
  static const int DEPTH_WRITEMASK = WebGL.WebGL.DEPTH_WRITEMASK;
  static const int DITHER = WebGL.WebGL.DITHER;
  static const int ELEMENT_ARRAY_BUFFER_BINDING = WebGL.WebGL.ELEMENT_ARRAY_BUFFER_BINDING;
  static const int FRAMEBUFFER_BINDING = WebGL.WebGL.FRAMEBUFFER_BINDING;
  static const int FRONT_FACE = WebGL.WebGL.FRONT_FACE;
  static const int GENERATE_MIPMAP_HINT = WebGL.WebGL.GENERATE_MIPMAP_HINT;
  static const int GREEN_BITS = WebGL.WebGL.GREEN_BITS;
  static const int IMPLEMENTATION_COLOR_READ_FORMAT = WebGL.WebGL.IMPLEMENTATION_COLOR_READ_FORMAT;
  static const int IMPLEMENTATION_COLOR_READ_TYPE = WebGL.WebGL.IMPLEMENTATION_COLOR_READ_TYPE;
  static const int LINE_WIDTH = WebGL.WebGL.LINE_WIDTH;
  static const int MAX_COMBINED_TEXTURE_IMAGE_UNITS = WebGL.WebGL.MAX_COMBINED_TEXTURE_IMAGE_UNITS;
  static const int MAX_CUBE_MAP_TEXTURE_SIZE = WebGL.WebGL.MAX_CUBE_MAP_TEXTURE_SIZE;
  static const int MAX_FRAGMENT_UNIFORM_VECTORS = WebGL.WebGL.MAX_FRAGMENT_UNIFORM_VECTORS;
  static const int MAX_RENDERBUFFER_SIZE = WebGL.WebGL.MAX_RENDERBUFFER_SIZE;
  static const int MAX_TEXTURE_IMAGE_UNITS = WebGL.WebGL.MAX_TEXTURE_IMAGE_UNITS;
  static const int MAX_TEXTURE_SIZE = WebGL.WebGL.MAX_TEXTURE_SIZE;
  static const int MAX_VARYING_VECTORS = WebGL.WebGL.MAX_VARYING_VECTORS;
  static const int MAX_VERTEX_ATTRIBS = WebGL.WebGL.MAX_VERTEX_ATTRIBS;
  static const int MAX_VERTEX_TEXTURE_IMAGE_UNITS = WebGL.WebGL.MAX_VERTEX_TEXTURE_IMAGE_UNITS;
  static const int MAX_VERTEX_UNIFORM_VECTORS = WebGL.WebGL.MAX_VERTEX_UNIFORM_VECTORS;
  static const int MAX_VIEWPORT_DIMS = WebGL.WebGL.MAX_VIEWPORT_DIMS;
  static const int PACK_ALIGNMENT = WebGL.WebGL.PACK_ALIGNMENT;
  static const int POLYGON_OFFSET_FACTOR = WebGL.WebGL.POLYGON_OFFSET_FACTOR;
  static const int POLYGON_OFFSET_FILL = WebGL.WebGL.POLYGON_OFFSET_FILL;
  static const int POLYGON_OFFSET_UNITS = WebGL.WebGL.POLYGON_OFFSET_UNITS;
  static const int RED_BITS = WebGL.WebGL.RED_BITS;
  static const int RENDERBUFFER_BINDING = WebGL.WebGL.RENDERBUFFER_BINDING;
  static const int RENDERER = WebGL.WebGL.RENDERER;
  static const int SAMPLE_BUFFERS = WebGL.WebGL.SAMPLE_BUFFERS;
  static const int SAMPLE_COVERAGE_INVERT = WebGL.WebGL.SAMPLE_COVERAGE_INVERT;
  static const int SAMPLE_COVERAGE_VALUE = WebGL.WebGL.SAMPLE_COVERAGE_VALUE;
  static const int SAMPLES = WebGL.WebGL.SAMPLES;
  static const int SCISSOR_BOX = WebGL.WebGL.SCISSOR_BOX;
  static const int SCISSOR_TEST = WebGL.WebGL.SCISSOR_TEST;
  static const int SHADING_LANGUAGE_VERSION = WebGL.WebGL.SHADING_LANGUAGE_VERSION;
  static const int STENCIL_BACK_FAIL = WebGL.WebGL.STENCIL_BACK_FAIL;
  static const int STENCIL_BACK_FUNC = WebGL.WebGL.STENCIL_BACK_FUNC;
  static const int STENCIL_BACK_PASS_DEPTH_FAIL = WebGL.WebGL.STENCIL_BACK_PASS_DEPTH_FAIL;
  static const int STENCIL_BACK_PASS_DEPTH_PASS = WebGL.WebGL.STENCIL_BACK_PASS_DEPTH_PASS;
  static const int STENCIL_BACK_REF = WebGL.WebGL.STENCIL_BACK_REF;
  static const int STENCIL_BACK_VALUE_MASK = WebGL.WebGL.STENCIL_BACK_VALUE_MASK;
  static const int STENCIL_BACK_WRITEMASK = WebGL.WebGL.STENCIL_BACK_WRITEMASK;
  static const int STENCIL_BITS = WebGL.WebGL.STENCIL_BITS;
  static const int STENCIL_CLEAR_VALUE = WebGL.WebGL.STENCIL_CLEAR_VALUE;
  static const int STENCIL_FAIL = WebGL.WebGL.STENCIL_FAIL;
  static const int STENCIL_FUNC = WebGL.WebGL.STENCIL_FUNC;
  static const int STENCIL_PASS_DEPTH_FAIL = WebGL.WebGL.STENCIL_PASS_DEPTH_FAIL;
  static const int STENCIL_PASS_DEPTH_PASS = WebGL.WebGL.STENCIL_PASS_DEPTH_PASS;
  static const int STENCIL_REF = WebGL.WebGL.STENCIL_REF;
  static const int STENCIL_TEST = WebGL.WebGL.STENCIL_TEST;
  static const int STENCIL_VALUE_MASK = WebGL.WebGL.STENCIL_VALUE_MASK;
  static const int STENCIL_WRITEMASK = WebGL.WebGL.STENCIL_WRITEMASK;
  static const int SUBPIXEL_BITS = WebGL.WebGL.SUBPIXEL_BITS;
  static const int TEXTURE_BINDING_2D = WebGL.WebGL.TEXTURE_BINDING_2D;
  static const int TEXTURE_BINDING_CUBE_MAP = WebGL.WebGL.TEXTURE_BINDING_CUBE_MAP;
  static const int UNPACK_ALIGNMENT = WebGL.WebGL.UNPACK_ALIGNMENT;
  static const int UNPACK_COLORSPACE_CONVERSION_WEBGL = WebGL.WebGL.UNPACK_COLORSPACE_CONVERSION_WEBGL;
  static const int UNPACK_FLIP_Y_WEBGL = WebGL.WebGL.UNPACK_FLIP_Y_WEBGL;
  static const int UNPACK_PREMULTIPLY_ALPHA_WEBGL = WebGL.WebGL.UNPACK_PREMULTIPLY_ALPHA_WEBGL;
  static const int VENDOR = WebGL.WebGL.VENDOR;
  static const int VERSION = WebGL.WebGL.VERSION;
  static const int VIEWPORT = WebGL.WebGL.VIEWPORT;
}

//WebGLRenderBuffers

//@reflector
class RenderBufferParameters {
  static const int RENDERBUFFER_WIDTH = WebGL.WebGL.RENDERBUFFER_WIDTH;
  static const int RENDERBUFFER_HEIGHT = WebGL.WebGL.RENDERBUFFER_HEIGHT;
  static const int RENDERBUFFER_INTERNAL_FORMAT = WebGL.WebGL.RENDERBUFFER_INTERNAL_FORMAT;
  static const int RENDERBUFFER_GREEN_SIZE = WebGL.WebGL.RENDERBUFFER_GREEN_SIZE;
  static const int RENDERBUFFER_BLUE_SIZE = WebGL.WebGL.RENDERBUFFER_BLUE_SIZE;
  static const int RENDERBUFFER_RED_SIZE = WebGL.WebGL.RENDERBUFFER_RED_SIZE;
  static const int RENDERBUFFER_ALPHA_SIZE = WebGL.WebGL.RENDERBUFFER_ALPHA_SIZE;
  static const int RENDERBUFFER_DEPTH_SIZE = WebGL.WebGL.RENDERBUFFER_DEPTH_SIZE;
  static const int RENDERBUFFER_STENCIL_SIZE = WebGL.WebGL.RENDERBUFFER_STENCIL_SIZE;
}

//@reflector
class RenderBufferTarget {
  static const int RENDERBUFFER = WebGL.WebGL.RENDERBUFFER;
}

//@reflector
class RenderBufferInternalFormatType {
  static const int RGBA4 = WebGL.WebGL.RGBA4;
  static const int RGB565 = WebGL.WebGL.RGB565;
  static const int RGB5_A1 = WebGL.WebGL.RGB5_A1;
  static const int DEPTH_COMPONENT16 = WebGL.WebGL.DEPTH_COMPONENT16;
  static const int STENCIL_INDEX8 = WebGL.WebGL.STENCIL_INDEX8;
  static const int DEPTH_STENCIL = WebGL.WebGL.DEPTH_STENCIL;
}

//WebGLFrameBuffers

//@reflector
class FrameBufferStatus {
  static const int FRAMEBUFFER_COMPLETE = WebGL.WebGL.FRAMEBUFFER_COMPLETE;
  static const int FRAMEBUFFER_INCOMPLETE_ATTACHMENT = WebGL.WebGL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT;
  static const int FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = WebGL.WebGL.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;
  static const int FRAMEBUFFER_INCOMPLETE_DIMENSIONS = WebGL.WebGL.FRAMEBUFFER_INCOMPLETE_DIMENSIONS;
  static const int FRAMEBUFFER_UNSUPPORTED = WebGL.WebGL.FRAMEBUFFER_UNSUPPORTED;
}

//@reflector
class FrameBufferTarget {
  static const int FRAMEBUFFER = WebGL.WebGL.FRAMEBUFFER;
}

//@reflector
class FrameBufferAttachment {
  static const int COLOR_ATTACHMENT0 = WebGL.WebGL.COLOR_ATTACHMENT0;
  static const int DEPTH_ATTACHMENT = WebGL.WebGL.DEPTH_ATTACHMENT;
  static const int STENCIL_ATTACHMENT = WebGL.WebGL.STENCIL_ATTACHMENT;
}

//@reflector
class FrameBufferAttachmentType {
  static const int TEXTURE = WebGL.WebGL.TEXTURE;
  static const int RENDERBUFFER = WebGL.WebGL.RENDERBUFFER;
  static const int NONE = WebGL.WebGL.NONE;
}

//@reflector
class FrameBufferAttachmentParameters {
  static const int FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;
  static const int FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;
  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;
  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = WebGL.WebGL.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;
}

//@reflector
class TextureAttachmentTarget {
  static const int TEXTURE_2D = WebGL.WebGL.TEXTURE_2D;
  static const int TEXTURE_CUBE_MAP_POSITIVE_X = WebGL.WebGL.TEXTURE_CUBE_MAP_POSITIVE_X;
  static const int TEXTURE_CUBE_MAP_NEGATIVE_X = WebGL.WebGL.TEXTURE_CUBE_MAP_NEGATIVE_X;
  static const int TEXTURE_CUBE_MAP_POSITIVE_Y = WebGL.WebGL.TEXTURE_CUBE_MAP_POSITIVE_Y;
  static const int TEXTURE_CUBE_MAP_NEGATIVE_Y = WebGL.WebGL.TEXTURE_CUBE_MAP_NEGATIVE_Y;
  static const int TEXTURE_CUBE_MAP_POSITIVE_Z = WebGL.WebGL.TEXTURE_CUBE_MAP_POSITIVE_Z;
  static const int TEXTURE_CUBE_MAP_NEGATIVE_Z = WebGL.WebGL.TEXTURE_CUBE_MAP_NEGATIVE_Z;

  /// need to iterate instead of : gl.TEXTURE_CUBE_MAP_POSITIVE_X + i
  static List<int> TEXTURE_CUBE_MAPS = [
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
class BufferType {
  static const int ARRAY_BUFFER = WebGL.WebGL.ARRAY_BUFFER;
  static const int ELEMENT_ARRAY_BUFFER = WebGL.WebGL.ELEMENT_ARRAY_BUFFER;

  static GLEnum.BufferType getByIndex(int index) =>
      GLEnum.BufferType.getByIndex(index);
}

//@reflector
class BufferUsageType {
  static const int STATIC_DRAW = WebGL.WebGL.STATIC_DRAW;
  static const int DYNAMIC_DRAW = WebGL.WebGL.DYNAMIC_DRAW;
  static const int STREAM_DRAW = WebGL.WebGL.STREAM_DRAW;
}

//@reflector
class BufferParameters {
  static const int BUFFER_SIZE = WebGL.WebGL.BUFFER_SIZE;
  static const int BUFFER_USAGE = WebGL.WebGL.BUFFER_USAGE;
}

//WebGLPrograms

//@reflector
class ProgramParameterGlEnum {
  static const int DELETE_STATUS = WebGL.WebGL.DELETE_STATUS;
  static const int LINK_STATUS = WebGL.WebGL.LINK_STATUS;
  static const int VALIDATE_STATUS = WebGL.WebGL.VALIDATE_STATUS;
  static const int ATTACHED_SHADERS = WebGL.WebGL.ATTACHED_SHADERS;
  static const int ACTIVE_ATTRIBUTES = WebGL.WebGL.ACTIVE_ATTRIBUTES;
  static const int ACTIVE_UNIFORMS = WebGL.WebGL.ACTIVE_UNIFORMS;
}

//@reflector
class VertexAttribArrayType {
  static const int BYTE = WebGL.WebGL.BYTE;
  static const int UNSIGNED_BYTE = 
          WebGL.WebGL.UNSIGNED_BYTE;
  static const int SHORT = WebGL.WebGL.SHORT;
  static const int UNSIGNED_SHORT = 
          WebGL.WebGL.UNSIGNED_SHORT;
  static const int FLOAT = WebGL.WebGL.FLOAT;

  static GLEnum.VertexAttribArrayType getByIndex(int index) =>
      GLEnum.VertexAttribArrayType.getByIndex(index);
}

//WebGLTextures

//@reflector
class TextureTarget {
  static const int TEXTURE_2D = WebGL.WebGL.TEXTURE_2D;
  static const int TEXTURE_CUBE_MAP = WebGL.WebGL.TEXTURE_CUBE_MAP;
}

//@reflector
class TextureUnit {
  static const int TEXTURE0 = WebGL.WebGL.TEXTURE0;
  static const int TEXTURE1 = WebGL.WebGL.TEXTURE1;
  static const int TEXTURE2 = WebGL.WebGL.TEXTURE2;
  static const int TEXTURE3 = WebGL.WebGL.TEXTURE3;
  static const int TEXTURE4 = WebGL.WebGL.TEXTURE4;
  static const int TEXTURE5 = WebGL.WebGL.TEXTURE5;
  static const int TEXTURE6 = WebGL.WebGL.TEXTURE6;
  static const int TEXTURE7 = WebGL.WebGL.TEXTURE7;
  static const int TEXTURE8 = WebGL.WebGL.TEXTURE8;
  static const int TEXTURE9 = WebGL.WebGL.TEXTURE9;
  static const int TEXTURE10 = WebGL.WebGL.TEXTURE10;
  static const int TEXTURE11 = WebGL.WebGL.TEXTURE11;
  static const int TEXTURE12 = WebGL.WebGL.TEXTURE12;
  static const int TEXTURE13 = WebGL.WebGL.TEXTURE13;
  static const int TEXTURE14 = WebGL.WebGL.TEXTURE14;
  static const int TEXTURE15 = WebGL.WebGL.TEXTURE15;
  static const int TEXTURE16 = WebGL.WebGL.TEXTURE16;
  static const int TEXTURE17 = WebGL.WebGL.TEXTURE17;
  static const int TEXTURE18 = WebGL.WebGL.TEXTURE18;
  static const int TEXTURE19 = WebGL.WebGL.TEXTURE19;
  static const int TEXTURE20 = WebGL.WebGL.TEXTURE20;
  static const int TEXTURE21 = WebGL.WebGL.TEXTURE21;
  static const int TEXTURE22 = WebGL.WebGL.TEXTURE22;
  static const int TEXTURE23 = WebGL.WebGL.TEXTURE23;
  static const int TEXTURE24 = WebGL.WebGL.TEXTURE24;
  static const int TEXTURE25 = WebGL.WebGL.TEXTURE25;
  static const int TEXTURE26 = WebGL.WebGL.TEXTURE26;
  static const int TEXTURE27 = WebGL.WebGL.TEXTURE27;
  static const int TEXTURE28 = WebGL.WebGL.TEXTURE28;
  static const int TEXTURE29 = WebGL.WebGL.TEXTURE29;
  static const int TEXTURE30 = WebGL.WebGL.TEXTURE30;
  static const int TEXTURE31 = WebGL.WebGL.TEXTURE31;
}

//@reflector
class TextureParameter {
  static const int TEXTURE_MAG_FILTER = WebGL.WebGL.TEXTURE_MAG_FILTER;
  static const int TEXTURE_MIN_FILTER = WebGL.WebGL.TEXTURE_MIN_FILTER;
  static const int TEXTURE_WRAP_S = WebGL.WebGL.TEXTURE_WRAP_S;
  static const int TEXTURE_WRAP_T = WebGL.WebGL.TEXTURE_WRAP_T;
}

//@reflector
abstract class TextureSetParameterType{}

//@reflector
class TextureFilterType extends TextureSetParameterType {
  static const int LINEAR = WebGL.WebGL.LINEAR;
  static const int NEAREST = WebGL.WebGL.NEAREST;
  static const int NEAREST_MIPMAP_NEAREST = WebGL.WebGL.NEAREST_MIPMAP_NEAREST;
  static const int LINEAR_MIPMAP_NEAREST = WebGL.WebGL.LINEAR_MIPMAP_NEAREST;
  static const int NEAREST_MIPMAP_LINEAR = WebGL.WebGL.NEAREST_MIPMAP_LINEAR;
  static const int LINEAR_MIPMAP_LINEAR = WebGL.WebGL.LINEAR_MIPMAP_LINEAR;
}

//@reflector
class TextureMagnificationFilterType extends TextureFilterType {
  static const int LINEAR = WebGL.WebGL.LINEAR;
  static const int NEAREST = WebGL.WebGL.NEAREST;
}

//@reflector
class TextureMinificationFilterType extends TextureFilterType {
  static const int LINEAR = WebGL.WebGL.LINEAR;
  static const int NEAREST = WebGL.WebGL.NEAREST;
  static const int NEAREST_MIPMAP_NEAREST = WebGL.WebGL.NEAREST_MIPMAP_NEAREST;
  static const int LINEAR_MIPMAP_NEAREST = WebGL.WebGL.LINEAR_MIPMAP_NEAREST;
  static const int NEAREST_MIPMAP_LINEAR = WebGL.WebGL.NEAREST_MIPMAP_LINEAR;
  static const int LINEAR_MIPMAP_LINEAR = WebGL.WebGL.LINEAR_MIPMAP_LINEAR;
}

//@reflector
class TextureWrapType extends TextureSetParameterType {
  static const int REPEAT = WebGL.WebGL.REPEAT;
  static const int CLAMP_TO_EDGE = WebGL.WebGL.CLAMP_TO_EDGE;
  static const int MIRRORED_REPEAT = WebGL.WebGL.MIRRORED_REPEAT;
}

//@reflector
class TextureInternalFormat {
  static const int ALPHA = WebGL.WebGL.ALPHA;
  static const int RGB = WebGL.WebGL.RGB;
  static const int RGBA = WebGL.WebGL.RGBA;
  static const int LUMINANCE = WebGL.WebGL.LUMINANCE;
  static const int LUMINANCE_ALPHA = 
          WebGL.WebGL.LUMINANCE_ALPHA;
}

//@reflector
class TexelDataType {
  static const int UNSIGNED_BYTE = WebGL.WebGL.UNSIGNED_BYTE;
  static const int UNSIGNED_SHORT_5_6_5 = WebGL.WebGL.UNSIGNED_SHORT_5_6_5;
  static const int UNSIGNED_SHORT_4_4_4_4 = WebGL.WebGL.UNSIGNED_SHORT_4_4_4_4;
  static const int UNSIGNED_SHORT_5_5_5_1 = WebGL.WebGL.UNSIGNED_SHORT_5_5_5_1;
}

//WebGLShaders

//@reflector
class ShaderVariableType {
  static const int FLOAT_VEC2 = WebGL.WebGL.FLOAT_VEC2;
  static const int FLOAT_VEC3 = WebGL.WebGL.FLOAT_VEC3;
  static const int FLOAT_VEC4 = WebGL.WebGL.FLOAT_VEC4;
  static const int INT_VEC2 = WebGL.WebGL.INT_VEC2;
  static const int INT_VEC3 = WebGL.WebGL.INT_VEC3;
  static const int INT_VEC4 = WebGL.WebGL.INT_VEC4;
  static const int BOOL = WebGL.WebGL.BOOL;
  static const int BOOL_VEC2 = WebGL.WebGL.BOOL_VEC2;
  static const int BOOL_VEC3 = WebGL.WebGL.BOOL_VEC3;
  static const int BOOL_VEC4 = WebGL.WebGL.BOOL_VEC4;
  static const int FLOAT_MAT2 = WebGL.WebGL.FLOAT_MAT2;
  static const int FLOAT_MAT3 = WebGL.WebGL.FLOAT_MAT3;
  static const int FLOAT_MAT4 = WebGL.WebGL.FLOAT_MAT4;
  static const int SAMPLER_2D = WebGL.WebGL.SAMPLER_2D;
  static const int SAMPLER_CUBE = WebGL.WebGL.SAMPLER_CUBE;
  static const int BYTE = WebGL.WebGL.BYTE;
  static const int UNSIGNED_BYTE = WebGL.WebGL.UNSIGNED_BYTE;
  static const int SHORT = WebGL.WebGL.SHORT;
  static const int UNSIGNED_SHORT = WebGL.WebGL.UNSIGNED_SHORT;
  static const int INT = WebGL.WebGL.INT;
  static const int UNSIGNED_INT = WebGL.WebGL.UNSIGNED_INT;
  static const int FLOAT = WebGL.WebGL.FLOAT;

  static int getByComponentAndType(String component, String type)
  {
        Map<String, int> values = {
        "FLOAT_VEC2" : FLOAT_VEC2,
        "FLOAT_VEC3" : FLOAT_VEC3,
        "FLOAT_VEC4" : FLOAT_VEC4,
        "INT_VEC2" : INT_VEC2,
        "INT_VEC3" : INT_VEC3,
        "INT_VEC4" : INT_VEC4,
        "BOOL" : BOOL,
        "BOOL_VEC2": BOOL_VEC2,
        "BOOL_VEC3" : BOOL_VEC3,
        "BOOL_VEC4" : BOOL_VEC4,
        "FLOAT_MAT2" : FLOAT_MAT2,
        "FLOAT_MAT3" : FLOAT_MAT3,
        "FLOAT_MAT4" : FLOAT_MAT4,
        "SAMPLER_2D": SAMPLER_2D,
        "SAMPLER_CUBE" : SAMPLER_CUBE,
        "BYTE" : BYTE,
        "UNSIGNED_BYTE" : UNSIGNED_BYTE,
        "SHORT" : SHORT,
        "UNSIGNED_SHORT" : UNSIGNED_SHORT,
        "INT" : INT,
        "UNSIGNED_INT" : UNSIGNED_INT,
        "FLOAT" : FLOAT
      };
    String key = values.keys.toList()
      .firstWhere((s)=>s.contains(component) && s.contains(type), orElse:()=> null);

    return values[key];
  }

}

//@reflector
class PrecisionType {
  static const int LOW_INT = WebGL.WebGL.LOW_INT;
  static const int LOW_FLOAT = WebGL.WebGL.LOW_FLOAT;
  static const int MEDIUM_INT = WebGL.WebGL.MEDIUM_INT;
  static const int MEDIUM_FLOAT = WebGL.WebGL.MEDIUM_FLOAT;
  static const int HIGH_INT = WebGL.WebGL.HIGH_INT;
  static const int HIGH_FLOAT = WebGL.WebGL.HIGH_FLOAT;
}

//@reflector
class ShaderType {
  static const int FRAGMENT_SHADER = WebGL.WebGL.FRAGMENT_SHADER;
  static const int VERTEX_SHADER = WebGL.WebGL.VERTEX_SHADER;
}

//@reflector
class ShaderParameters {
  static const int DELETE_STATUS = WebGL.WebGL.DELETE_STATUS;
  static const int COMPILE_STATUS = WebGL.WebGL.COMPILE_STATUS;
  static const int SHADER_TYPE = WebGL.WebGL.SHADER_TYPE;
}

//@reflector
class VertexAttribGlEnum {
  static const int VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;
  static const int VERTEX_ATTRIB_ARRAY_ENABLED = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_ENABLED;
  static const int VERTEX_ATTRIB_ARRAY_SIZE = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_SIZE;
  static const int VERTEX_ATTRIB_ARRAY_STRIDE = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_STRIDE;
  static const int VERTEX_ATTRIB_ARRAY_TYPE = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_TYPE;
  static const int VERTEX_ATTRIB_ARRAY_NORMALIZED = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_NORMALIZED;
  static const int VERTEX_ATTRIB_ARRAY_POINTER = WebGL.WebGL.VERTEX_ATTRIB_ARRAY_POINTER;
  static const int CURRENT_VERTEX_ATTRIB = WebGL.WebGL.CURRENT_VERTEX_ATTRIB;
}
