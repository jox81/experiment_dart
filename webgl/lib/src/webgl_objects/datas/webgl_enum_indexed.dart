import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;



//WebGLRenderingContext

class EnableCapabilityType {
  static const int BLEND = WebGL.RenderingContext.BLEND;
  static const int CULL_FACE = WebGL.RenderingContext.CULL_FACE;
  static const int DEPTH_TEST = WebGL.RenderingContext.DEPTH_TEST;
  static const int DITHER = WebGL.RenderingContext.DITHER;
  static const int POLYGON_OFFSET_FILL = WebGL.RenderingContext.POLYGON_OFFSET_FILL;
  static const int SAMPLE_ALPHA_TO_COVERAGE = WebGL.RenderingContext.SAMPLE_ALPHA_TO_COVERAGE;
  static const int SAMPLE_COVERAGE = WebGL.RenderingContext.SAMPLE_COVERAGE;
  static const int SCISSOR_TEST = WebGL.RenderingContext.SCISSOR_TEST;
  static const int STENCIL_TEST = WebGL.RenderingContext.STENCIL_TEST;
}

class FacingType {
  static const int FRONT = WebGL.RenderingContext.FRONT;
  static const int BACK = WebGL.RenderingContext.BACK;
  static const int FRONT_AND_BACK = WebGL.RenderingContext.FRONT_AND_BACK;
}

class ClearBufferMask {
  static const int DEPTH_BUFFER_BIT = WebGL.RenderingContext.DEPTH_BUFFER_BIT;
  static const int STENCIL_BUFFER_BIT = WebGL.RenderingContext.STENCIL_BUFFER_BIT;
  static const int COLOR_BUFFER_BIT = WebGL.RenderingContext.COLOR_BUFFER_BIT;
}

class FrontFaceDirection {
  static const int CW = WebGL.RenderingContext.CW;
  static const int CCW = WebGL.RenderingContext.CCW;
}

class PixelStorgeType {
  static const int PACK_ALIGNMENT = WebGL.RenderingContext.PACK_ALIGNMENT;
  static const int UNPACK_ALIGNMENT = WebGL.RenderingContext.UNPACK_ALIGNMENT;
  static const int UNPACK_FLIP_Y_WEBGL = WebGL.RenderingContext.UNPACK_FLIP_Y_WEBGL;
  static const int UNPACK_PREMULTIPLY_ALPHA_WEBGL = WebGL.RenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL;
  static const int UNPACK_COLORSPACE_CONVERSION_WEBGL = WebGL.RenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL;
}

class DrawMode {
  static const int POINTS = WebGL.RenderingContext.POINTS;
  static const int LINE_STRIP = WebGL.RenderingContext.LINE_STRIP;
  static const int LINE_LOOP = WebGL.RenderingContext.LINE_LOOP;
  static const int LINES = WebGL.RenderingContext.LINES;
  static const int TRIANGLE_STRIP = WebGL.RenderingContext.TRIANGLE_STRIP;
  static const int TRIANGLE_FAN = WebGL.RenderingContext.TRIANGLE_FAN;
  static const int TRIANGLES = WebGL.RenderingContext.TRIANGLES;
}

class BufferElementType {
  static const int UNSIGNED_BYTE = WebGL.RenderingContext.UNSIGNED_BYTE;
  static const int UNSIGNED_SHORT = WebGL.RenderingContext.UNSIGNED_SHORT;
}

class ReadPixelDataFormat {
  static const int ALPHA = WebGL.RenderingContext.ALPHA;
  static const int RGB = WebGL.RenderingContext.RGB;
  static const int RGBA = WebGL.RenderingContext.RGBA;
}

class ReadPixelDataType {
  static const int UNSIGNED_BYTE = WebGL.RenderingContext.UNSIGNED_BYTE;
  static const int UNSIGNED_SHORT_5_6_5 = WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5;
  static const int UNSIGNED_SHORT_4_4_4_4 = WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4;
  static const int UNSIGNED_SHORT_5_5_5_1 = WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1;
  static const int FLOAT = WebGL.RenderingContext.FLOAT;
}

class ComparisonFunction {
  static const int NEVER = WebGL.RenderingContext.NEVER;
  static const int LESS = WebGL.RenderingContext.LESS;
  static const int EQUAL = WebGL.RenderingContext.EQUAL;
  static const int LEQUAL = WebGL.RenderingContext.LEQUAL;
  static const int GREATER = WebGL.RenderingContext.GREATER;
  static const int NOTEQUAL = WebGL.RenderingContext.NOTEQUAL;
  static const int GEQUAL = WebGL.RenderingContext.GEQUAL;
  static const int ALWAYS = WebGL.RenderingContext.ALWAYS;
}

class ErrorCode {
  static const int NO_ERROR = WebGL.RenderingContext.NO_ERROR;
  static const int INVALID_ENUM = WebGL.RenderingContext.INVALID_ENUM;
  static const int INVALID_VALUE = WebGL.RenderingContext.INVALID_VALUE;
  static const int INVALID_OPERATION = WebGL.RenderingContext.INVALID_OPERATION;
  static const int INVALID_FRAMEBUFFER_OPERATION = WebGL.RenderingContext.INVALID_FRAMEBUFFER_OPERATION;
  static const int OUT_OF_MEMORY = WebGL.RenderingContext.OUT_OF_MEMORY;
  static const int CONTEXT_LOST_WEBGL = WebGL.RenderingContext.CONTEXT_LOST_WEBGL;
}

class HintMode {
  static const int FASTEST = WebGL.RenderingContext.FASTEST;
  static const int NICEST = WebGL.RenderingContext.NICEST;
  static const int DONT_CARE = WebGL.RenderingContext.DONT_CARE;
}

class StencilOpMode {
  static const int ZERO = WebGL.RenderingContext.ZERO;
  static const int KEEP = WebGL.RenderingContext.KEEP;
  static const int REPLACE = WebGL.RenderingContext.REPLACE;
  static const int INVERT = WebGL.RenderingContext.INVERT;
  static const int INCR = WebGL.RenderingContext.INCR;
  static const int INCR_WRAP = WebGL.RenderingContext.INCR_WRAP;
  static const int DECR = WebGL.RenderingContext.DECR;
  static const int DECR_WRAP = WebGL.RenderingContext.DECR_WRAP;
}

class BlendFactorMode {
  static const int ZERO = WebGL.RenderingContext.ZERO;
  static const int ONE = WebGL.RenderingContext.ONE;
  static const int SRC_COLOR = WebGL.RenderingContext.SRC_COLOR;
  static const int SRC_ALPHA = WebGL.RenderingContext.SRC_ALPHA;
  static const int SRC_ALPHA_SATURATE = WebGL.RenderingContext.SRC_ALPHA_SATURATE;
  static const int DST_COLOR = WebGL.RenderingContext.DST_COLOR;
  static const int DST_ALPHA = WebGL.RenderingContext.DST_ALPHA;
  static const int CONSTANT_COLOR = WebGL.RenderingContext.CONSTANT_COLOR;
  static const int CONSTANT_ALPHA = WebGL.RenderingContext.CONSTANT_ALPHA;
  static const int ONE_MINUS_SRC_COLOR = WebGL.RenderingContext.ONE_MINUS_SRC_COLOR;
  static const int ONE_MINUS_SRC_ALPHA = WebGL.RenderingContext.ONE_MINUS_SRC_ALPHA;
  static const int ONE_MINUS_DST_COLOR = WebGL.RenderingContext.ONE_MINUS_DST_COLOR;
  static const int ONE_MINUS_DST_ALPHA = WebGL.RenderingContext.ONE_MINUS_DST_ALPHA;
  static const int ONE_MINUS_CONSTANT_COLOR = WebGL.RenderingContext.ONE_MINUS_CONSTANT_COLOR;
  static const int ONE_MINUS_CONSTANT_ALPHA = WebGL.RenderingContext.ONE_MINUS_CONSTANT_ALPHA;
}

class BlendFunctionMode {
  static const int FUNC_ADD = WebGL.RenderingContext.FUNC_ADD;
  static const int FUNC_SUBTRACT = WebGL.RenderingContext.FUNC_SUBTRACT;
  static const int FUNC_REVERSE_SUBTRACT = WebGL.RenderingContext.FUNC_REVERSE_SUBTRACT;
}

class ContextParameter {
  static const int ACTIVE_TEXTURE = WebGL.RenderingContext.ACTIVE_TEXTURE;
  static const int ALIASED_LINE_WIDTH_RANGE = WebGL.RenderingContext.ALIASED_LINE_WIDTH_RANGE;
  static const int ALIASED_POINT_SIZE_RANGE = WebGL.RenderingContext.ALIASED_POINT_SIZE_RANGE;
  static const int ALPHA_BITS = WebGL.RenderingContext.ALPHA_BITS;
  static const int ARRAY_BUFFER_BINDING = WebGL.RenderingContext.ARRAY_BUFFER_BINDING;
  static const int BLEND = WebGL.RenderingContext.BLEND;
  static const int BLEND_COLOR = WebGL.RenderingContext.BLEND_COLOR;
  static const int BLEND_DST_ALPHA = WebGL.RenderingContext.BLEND_DST_ALPHA;
  static const int BLEND_DST_RGB = WebGL.RenderingContext.BLEND_DST_RGB;
  static const int BLEND_EQUATION = WebGL.RenderingContext.BLEND_EQUATION;
  static const int BLEND_EQUATION_ALPHA = WebGL.RenderingContext.BLEND_EQUATION_ALPHA;
  static const int BLEND_EQUATION_RGB = WebGL.RenderingContext.BLEND_EQUATION_RGB;
  static const int BLEND_SRC_ALPHA = WebGL.RenderingContext.BLEND_SRC_ALPHA;
  static const int BLEND_SRC_RGB = WebGL.RenderingContext.BLEND_SRC_RGB;
  static const int BLUE_BITS = WebGL.RenderingContext.BLUE_BITS;
  static const int COLOR_CLEAR_VALUE = WebGL.RenderingContext.COLOR_CLEAR_VALUE;
  static const int COLOR_WRITEMASK = WebGL.RenderingContext.COLOR_WRITEMASK;
  static const int COMPRESSED_TEXTURE_FORMATS = WebGL.RenderingContext.COMPRESSED_TEXTURE_FORMATS;
  static const int CULL_FACE_MODE = WebGL.RenderingContext.CULL_FACE_MODE;
  static const int CURRENT_PROGRAM = WebGL.RenderingContext.CURRENT_PROGRAM;
  static const int DEPTH_BITS = WebGL.RenderingContext.DEPTH_BITS;
  static const int DEPTH_CLEAR_VALUE = WebGL.RenderingContext.DEPTH_CLEAR_VALUE;
  static const int DEPTH_FUNC = WebGL.RenderingContext.DEPTH_FUNC;
  static const int DEPTH_RANGE = WebGL.RenderingContext.DEPTH_RANGE;
  static const int DEPTH_TEST = WebGL.RenderingContext.DEPTH_TEST;
  static const int DEPTH_WRITEMASK = WebGL.RenderingContext.DEPTH_WRITEMASK;
  static const int DITHER = WebGL.RenderingContext.DITHER;
  static const int ELEMENT_ARRAY_BUFFER_BINDING = WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER_BINDING;
  static const int FRAMEBUFFER_BINDING = WebGL.RenderingContext.FRAMEBUFFER_BINDING;
  static const int FRONT_FACE = WebGL.RenderingContext.FRONT_FACE;
  static const int GENERATE_MIPMAP_HINT = WebGL.RenderingContext.GENERATE_MIPMAP_HINT;
  static const int GREEN_BITS = WebGL.RenderingContext.GREEN_BITS;
  static const int IMPLEMENTATION_COLOR_READ_FORMAT = WebGL.RenderingContext.IMPLEMENTATION_COLOR_READ_FORMAT;
  static const int IMPLEMENTATION_COLOR_READ_TYPE = WebGL.RenderingContext.IMPLEMENTATION_COLOR_READ_TYPE;
  static const int LINE_WIDTH = WebGL.RenderingContext.LINE_WIDTH;
  static const int MAX_COMBINED_TEXTURE_IMAGE_UNITS = WebGL.RenderingContext.MAX_COMBINED_TEXTURE_IMAGE_UNITS;
  static const int MAX_CUBE_MAP_TEXTURE_SIZE = WebGL.RenderingContext.MAX_CUBE_MAP_TEXTURE_SIZE;
  static const int MAX_FRAGMENT_UNIFORM_VECTORS = WebGL.RenderingContext.MAX_FRAGMENT_UNIFORM_VECTORS;
  static const int MAX_RENDERBUFFER_SIZE = WebGL.RenderingContext.MAX_RENDERBUFFER_SIZE;
  static const int MAX_TEXTURE_IMAGE_UNITS = WebGL.RenderingContext.MAX_TEXTURE_IMAGE_UNITS;
  static const int MAX_TEXTURE_SIZE = WebGL.RenderingContext.MAX_TEXTURE_SIZE;
  static const int MAX_VARYING_VECTORS = WebGL.RenderingContext.MAX_VARYING_VECTORS;
  static const int MAX_VERTEX_ATTRIBS = WebGL.RenderingContext.MAX_VERTEX_ATTRIBS;
  static const int MAX_VERTEX_TEXTURE_IMAGE_UNITS = WebGL.RenderingContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS;
  static const int MAX_VERTEX_UNIFORM_VECTORS = WebGL.RenderingContext.MAX_VERTEX_UNIFORM_VECTORS;
  static const int MAX_VIEWPORT_DIMS = WebGL.RenderingContext.MAX_VIEWPORT_DIMS;
  static const int PACK_ALIGNMENT = WebGL.RenderingContext.PACK_ALIGNMENT;
  static const int POLYGON_OFFSET_FACTOR = WebGL.RenderingContext.POLYGON_OFFSET_FACTOR;
  static const int POLYGON_OFFSET_FILL = WebGL.RenderingContext.POLYGON_OFFSET_FILL;
  static const int POLYGON_OFFSET_UNITS = WebGL.RenderingContext.POLYGON_OFFSET_UNITS;
  static const int RED_BITS = WebGL.RenderingContext.RED_BITS;
  static const int RENDERBUFFER_BINDING = WebGL.RenderingContext.RENDERBUFFER_BINDING;
  static const int RENDERER = WebGL.RenderingContext.RENDERER;
  static const int SAMPLE_BUFFERS = WebGL.RenderingContext.SAMPLE_BUFFERS;
  static const int SAMPLE_COVERAGE_INVERT = WebGL.RenderingContext.SAMPLE_COVERAGE_INVERT;
  static const int SAMPLE_COVERAGE_VALUE = WebGL.RenderingContext.SAMPLE_COVERAGE_VALUE;
  static const int SAMPLES = WebGL.RenderingContext.SAMPLES;
  static const int SCISSOR_BOX = WebGL.RenderingContext.SCISSOR_BOX;
  static const int SCISSOR_TEST = WebGL.RenderingContext.SCISSOR_TEST;
  static const int SHADING_LANGUAGE_VERSION = WebGL.RenderingContext.SHADING_LANGUAGE_VERSION;
  static const int STENCIL_BACK_FAIL = WebGL.RenderingContext.STENCIL_BACK_FAIL;
  static const int STENCIL_BACK_FUNC = WebGL.RenderingContext.STENCIL_BACK_FUNC;
  static const int STENCIL_BACK_PASS_DEPTH_FAIL = WebGL.RenderingContext.STENCIL_BACK_PASS_DEPTH_FAIL;
  static const int STENCIL_BACK_PASS_DEPTH_PASS = WebGL.RenderingContext.STENCIL_BACK_PASS_DEPTH_PASS;
  static const int STENCIL_BACK_REF = WebGL.RenderingContext.STENCIL_BACK_REF;
  static const int STENCIL_BACK_VALUE_MASK = WebGL.RenderingContext.STENCIL_BACK_VALUE_MASK;
  static const int STENCIL_BACK_WRITEMASK = WebGL.RenderingContext.STENCIL_BACK_WRITEMASK;
  static const int STENCIL_BITS = WebGL.RenderingContext.STENCIL_BITS;
  static const int STENCIL_CLEAR_VALUE = WebGL.RenderingContext.STENCIL_CLEAR_VALUE;
  static const int STENCIL_FAIL = WebGL.RenderingContext.STENCIL_FAIL;
  static const int STENCIL_FUNC = WebGL.RenderingContext.STENCIL_FUNC;
  static const int STENCIL_PASS_DEPTH_FAIL = WebGL.RenderingContext.STENCIL_PASS_DEPTH_FAIL;
  static const int STENCIL_PASS_DEPTH_PASS = WebGL.RenderingContext.STENCIL_PASS_DEPTH_PASS;
  static const int STENCIL_REF = WebGL.RenderingContext.STENCIL_REF;
  static const int STENCIL_TEST = WebGL.RenderingContext.STENCIL_TEST;
  static const int STENCIL_VALUE_MASK = WebGL.RenderingContext.STENCIL_VALUE_MASK;
  static const int STENCIL_WRITEMASK = WebGL.RenderingContext.STENCIL_WRITEMASK;
  static const int SUBPIXEL_BITS = WebGL.RenderingContext.SUBPIXEL_BITS;
  static const int TEXTURE_BINDING_2D = WebGL.RenderingContext.TEXTURE_BINDING_2D;
  static const int TEXTURE_BINDING_CUBE_MAP = WebGL.RenderingContext.TEXTURE_BINDING_CUBE_MAP;
  static const int UNPACK_ALIGNMENT = WebGL.RenderingContext.UNPACK_ALIGNMENT;
  static const int UNPACK_COLORSPACE_CONVERSION_WEBGL = WebGL.RenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL;
  static const int UNPACK_FLIP_Y_WEBGL = WebGL.RenderingContext.UNPACK_FLIP_Y_WEBGL;
  static const int UNPACK_PREMULTIPLY_ALPHA_WEBGL = WebGL.RenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL;
  static const int VENDOR = WebGL.RenderingContext.VENDOR;
  static const int VERSION = WebGL.RenderingContext.VERSION;
  static const int VIEWPORT = WebGL.RenderingContext.VIEWPORT;
}

//WebGLRenderBuffers

class RenderBufferParameters {
  static const int RENDERBUFFER_WIDTH = WebGL.RenderingContext.RENDERBUFFER_WIDTH;
  static const int RENDERBUFFER_HEIGHT = WebGL.RenderingContext.RENDERBUFFER_HEIGHT;
  static const int RENDERBUFFER_INTERNAL_FORMAT = WebGL.RenderingContext.RENDERBUFFER_INTERNAL_FORMAT;
  static const int RENDERBUFFER_GREEN_SIZE = WebGL.RenderingContext.RENDERBUFFER_GREEN_SIZE;
  static const int RENDERBUFFER_BLUE_SIZE = WebGL.RenderingContext.RENDERBUFFER_BLUE_SIZE;
  static const int RENDERBUFFER_RED_SIZE = WebGL.RenderingContext.RENDERBUFFER_RED_SIZE;
  static const int RENDERBUFFER_ALPHA_SIZE = WebGL.RenderingContext.RENDERBUFFER_ALPHA_SIZE;
  static const int RENDERBUFFER_DEPTH_SIZE = WebGL.RenderingContext.RENDERBUFFER_DEPTH_SIZE;
  static const int RENDERBUFFER_STENCIL_SIZE = WebGL.RenderingContext.RENDERBUFFER_STENCIL_SIZE;
}

class RenderBufferTarget {
  static const int RENDERBUFFER = WebGL.RenderingContext.RENDERBUFFER;
}

class RenderBufferInternalFormatType {
  static const int RGBA4 = WebGL.RenderingContext.RGBA4;
  static const int RGB565 = WebGL.RenderingContext.RGB565;
  static const int RGB5_A1 = WebGL.RenderingContext.RGB5_A1;
  static const int DEPTH_COMPONENT16 = WebGL.RenderingContext.DEPTH_COMPONENT16;
  static const int STENCIL_INDEX8 = WebGL.RenderingContext.STENCIL_INDEX8;
  static const int DEPTH_STENCIL = WebGL.RenderingContext.DEPTH_STENCIL;
}

//WebGLFrameBuffers

class FrameBufferStatus {
  static const int FRAMEBUFFER_COMPLETE = WebGL.RenderingContext.FRAMEBUFFER_COMPLETE;
  static const int FRAMEBUFFER_INCOMPLETE_ATTACHMENT = WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT;
  static const int FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;
  static const int FRAMEBUFFER_INCOMPLETE_DIMENSIONS = WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS;
  static const int FRAMEBUFFER_UNSUPPORTED = WebGL.RenderingContext.FRAMEBUFFER_UNSUPPORTED;
}

class FrameBufferTarget {
  static const int FRAMEBUFFER = WebGL.RenderingContext.FRAMEBUFFER;
}

class FrameBufferAttachment {
  static const int COLOR_ATTACHMENT0 = WebGL.RenderingContext.COLOR_ATTACHMENT0;
  static const int DEPTH_ATTACHMENT = WebGL.RenderingContext.DEPTH_ATTACHMENT;
  static const int STENCIL_ATTACHMENT = WebGL.RenderingContext.STENCIL_ATTACHMENT;
}

class FrameBufferAttachmentType {
  static const int TEXTURE = WebGL.RenderingContext.TEXTURE;
  static const int RENDERBUFFER = WebGL.RenderingContext.RENDERBUFFER;
  static const int NONE = WebGL.RenderingContext.NONE;
}

class FrameBufferAttachmentParameters {
  static const int FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;
  static const int FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;
  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;
  static const int FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;
}

class TextureAttachmentTarget {
  static const int TEXTURE_2D = WebGL.RenderingContext.TEXTURE_2D;
  static const int TEXTURE_CUBE_MAP_POSITIVE_X = WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X;
  static const int TEXTURE_CUBE_MAP_NEGATIVE_X = WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X;
  static const int TEXTURE_CUBE_MAP_POSITIVE_Y = WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y;
  static const int TEXTURE_CUBE_MAP_NEGATIVE_Y = WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y;
  static const int TEXTURE_CUBE_MAP_POSITIVE_Z = WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z;
  static const int TEXTURE_CUBE_MAP_NEGATIVE_Z = WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z;

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

class BufferType {
  static const int ARRAY_BUFFER = WebGL.RenderingContext.ARRAY_BUFFER;
  static const int ELEMENT_ARRAY_BUFFER = WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER;

  static GLEnum.BufferType getByIndex(int index) =>
      GLEnum.BufferType.getByIndex(index);
}

class BufferUsageType {
  static const int STATIC_DRAW = WebGL.RenderingContext.STATIC_DRAW;
  static const int DYNAMIC_DRAW = WebGL.RenderingContext.DYNAMIC_DRAW;
  static const int STREAM_DRAW = WebGL.RenderingContext.STREAM_DRAW;
}

class BufferParameters {
  static const int BUFFER_SIZE = WebGL.RenderingContext.BUFFER_SIZE;
  static const int BUFFER_USAGE = WebGL.RenderingContext.BUFFER_USAGE;
}

//WebGLPrograms

class ProgramParameterGlEnum {
  static const int DELETE_STATUS = WebGL.RenderingContext.DELETE_STATUS;
  static const int LINK_STATUS = WebGL.RenderingContext.LINK_STATUS;
  static const int VALIDATE_STATUS = WebGL.RenderingContext.VALIDATE_STATUS;
  static const int ATTACHED_SHADERS = WebGL.RenderingContext.ATTACHED_SHADERS;
  static const int ACTIVE_ATTRIBUTES = WebGL.RenderingContext.ACTIVE_ATTRIBUTES;
  static const int ACTIVE_UNIFORMS = WebGL.RenderingContext.ACTIVE_UNIFORMS;
}

class VertexAttribArrayType {
  static const int BYTE = WebGL.RenderingContext.BYTE;
  static const int UNSIGNED_BYTE = 
          WebGL.RenderingContext.UNSIGNED_BYTE;
  static const int SHORT = WebGL.RenderingContext.SHORT;
  static const int UNSIGNED_SHORT = 
          WebGL.RenderingContext.UNSIGNED_SHORT;
  static const int FLOAT = WebGL.RenderingContext.FLOAT;

  static GLEnum.VertexAttribArrayType getByIndex(int index) =>
      GLEnum.VertexAttribArrayType.getByIndex(index);
}

//WebGLTextures

class TextureTarget {
  static const int TEXTURE_2D = WebGL.RenderingContext.TEXTURE_2D;
  static const int TEXTURE_CUBE_MAP = WebGL.RenderingContext.TEXTURE_CUBE_MAP;
}

class TextureUnit {
  static const int TEXTURE0 = WebGL.RenderingContext.TEXTURE0;
  static const int TEXTURE1 = WebGL.RenderingContext.TEXTURE1;
  static const int TEXTURE2 = WebGL.RenderingContext.TEXTURE2;
  static const int TEXTURE3 = WebGL.RenderingContext.TEXTURE3;
  static const int TEXTURE4 = WebGL.RenderingContext.TEXTURE4;
  static const int TEXTURE5 = WebGL.RenderingContext.TEXTURE5;
  static const int TEXTURE6 = WebGL.RenderingContext.TEXTURE6;
  static const int TEXTURE7 = WebGL.RenderingContext.TEXTURE7;
  static const int TEXTURE8 = WebGL.RenderingContext.TEXTURE8;
  static const int TEXTURE9 = WebGL.RenderingContext.TEXTURE9;
  static const int TEXTURE10 = WebGL.RenderingContext.TEXTURE10;
  static const int TEXTURE11 = WebGL.RenderingContext.TEXTURE11;
  static const int TEXTURE12 = WebGL.RenderingContext.TEXTURE12;
  static const int TEXTURE13 = WebGL.RenderingContext.TEXTURE13;
  static const int TEXTURE14 = WebGL.RenderingContext.TEXTURE14;
  static const int TEXTURE15 = WebGL.RenderingContext.TEXTURE15;
  static const int TEXTURE16 = WebGL.RenderingContext.TEXTURE16;
  static const int TEXTURE17 = WebGL.RenderingContext.TEXTURE17;
  static const int TEXTURE18 = WebGL.RenderingContext.TEXTURE18;
  static const int TEXTURE19 = WebGL.RenderingContext.TEXTURE19;
  static const int TEXTURE20 = WebGL.RenderingContext.TEXTURE20;
  static const int TEXTURE21 = WebGL.RenderingContext.TEXTURE21;
  static const int TEXTURE22 = WebGL.RenderingContext.TEXTURE22;
  static const int TEXTURE23 = WebGL.RenderingContext.TEXTURE23;
  static const int TEXTURE24 = WebGL.RenderingContext.TEXTURE24;
  static const int TEXTURE25 = WebGL.RenderingContext.TEXTURE25;
  static const int TEXTURE26 = WebGL.RenderingContext.TEXTURE26;
  static const int TEXTURE27 = WebGL.RenderingContext.TEXTURE27;
  static const int TEXTURE28 = WebGL.RenderingContext.TEXTURE28;
  static const int TEXTURE29 = WebGL.RenderingContext.TEXTURE29;
  static const int TEXTURE30 = WebGL.RenderingContext.TEXTURE30;
  static const int TEXTURE31 = WebGL.RenderingContext.TEXTURE31;
}

class TextureParameter {
  static const int TEXTURE_MAG_FILTER = WebGL.RenderingContext.TEXTURE_MAG_FILTER;
  static const int TEXTURE_MIN_FILTER = WebGL.RenderingContext.TEXTURE_MIN_FILTER;
  static const int TEXTURE_WRAP_S = WebGL.RenderingContext.TEXTURE_WRAP_S;
  static const int TEXTURE_WRAP_T = WebGL.RenderingContext.TEXTURE_WRAP_T;
}

abstract class TextureSetParameterType{}

class TextureFilterType extends TextureSetParameterType {
  static const int LINEAR = WebGL.RenderingContext.LINEAR;
  static const int NEAREST = WebGL.RenderingContext.NEAREST;
  static const int NEAREST_MIPMAP_NEAREST = WebGL.RenderingContext.NEAREST_MIPMAP_NEAREST;
  static const int LINEAR_MIPMAP_NEAREST = WebGL.RenderingContext.LINEAR_MIPMAP_NEAREST;
  static const int NEAREST_MIPMAP_LINEAR = WebGL.RenderingContext.NEAREST_MIPMAP_LINEAR;
  static const int LINEAR_MIPMAP_LINEAR = WebGL.RenderingContext.LINEAR_MIPMAP_LINEAR;
}

class TextureMagnificationFilterType extends TextureFilterType {
  static const int LINEAR = WebGL.RenderingContext.LINEAR;
  static const int NEAREST = WebGL.RenderingContext.NEAREST;
}

class TextureMinificationFilterType extends TextureFilterType {
  static const int LINEAR = WebGL.RenderingContext.LINEAR;
  static const int NEAREST = WebGL.RenderingContext.NEAREST;
  static const int NEAREST_MIPMAP_NEAREST = WebGL.RenderingContext.NEAREST_MIPMAP_NEAREST;
  static const int LINEAR_MIPMAP_NEAREST = WebGL.RenderingContext.LINEAR_MIPMAP_NEAREST;
  static const int NEAREST_MIPMAP_LINEAR = WebGL.RenderingContext.NEAREST_MIPMAP_LINEAR;
  static const int LINEAR_MIPMAP_LINEAR = WebGL.RenderingContext.LINEAR_MIPMAP_LINEAR;
}

class TextureWrapType extends TextureSetParameterType {
  static const int REPEAT = WebGL.RenderingContext.REPEAT;
  static const int CLAMP_TO_EDGE = WebGL.RenderingContext.CLAMP_TO_EDGE;
  static const int MIRRORED_REPEAT = WebGL.RenderingContext.MIRRORED_REPEAT;
}

class TextureInternalFormat {
  static const int ALPHA = WebGL.RenderingContext.ALPHA;
  static const int RGB = WebGL.RenderingContext.RGB;
  static const int RGBA = WebGL.RenderingContext.RGBA;
  static const int LUMINANCE = WebGL.RenderingContext.LUMINANCE;
  static const int LUMINANCE_ALPHA = 
          WebGL.RenderingContext.LUMINANCE_ALPHA;
}

class TexelDataType {
  static const int UNSIGNED_BYTE = WebGL.RenderingContext.UNSIGNED_BYTE;
  static const int UNSIGNED_SHORT_5_6_5 = WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5;
  static const int UNSIGNED_SHORT_4_4_4_4 = WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4;
  static const int UNSIGNED_SHORT_5_5_5_1 = WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1;
}

//WebGLShaders

class ShaderVariableType {
  static const int FLOAT_VEC2 = WebGL.RenderingContext.FLOAT_VEC2;
  static const int FLOAT_VEC3 = WebGL.RenderingContext.FLOAT_VEC3;
  static const int FLOAT_VEC4 = WebGL.RenderingContext.FLOAT_VEC4;
  static const int INT_VEC2 = WebGL.RenderingContext.INT_VEC2;
  static const int INT_VEC3 = WebGL.RenderingContext.INT_VEC3;
  static const int INT_VEC4 = WebGL.RenderingContext.INT_VEC4;
  static const int BOOL = WebGL.RenderingContext.BOOL;
  static const int BOOL_VEC2 = WebGL.RenderingContext.BOOL_VEC2;
  static const int BOOL_VEC3 = WebGL.RenderingContext.BOOL_VEC3;
  static const int BOOL_VEC4 = WebGL.RenderingContext.BOOL_VEC4;
  static const int FLOAT_MAT2 = WebGL.RenderingContext.FLOAT_MAT2;
  static const int FLOAT_MAT3 = WebGL.RenderingContext.FLOAT_MAT3;
  static const int FLOAT_MAT4 = WebGL.RenderingContext.FLOAT_MAT4;
  static const int SAMPLER_2D = WebGL.RenderingContext.SAMPLER_2D;
  static const int SAMPLER_CUBE = WebGL.RenderingContext.SAMPLER_CUBE;
  static const int BYTE = WebGL.RenderingContext.BYTE;
  static const int UNSIGNED_BYTE = WebGL.RenderingContext.UNSIGNED_BYTE;
  static const int SHORT = WebGL.RenderingContext.SHORT;
  static const int UNSIGNED_SHORT = WebGL.RenderingContext.UNSIGNED_SHORT;
  static const int INT = WebGL.RenderingContext.INT;
  static const int UNSIGNED_INT = WebGL.RenderingContext.UNSIGNED_INT;
  static const int FLOAT = WebGL.RenderingContext.FLOAT;

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

class PrecisionType {
  static const int LOW_INT = WebGL.RenderingContext.LOW_INT;
  static const int LOW_FLOAT = WebGL.RenderingContext.LOW_FLOAT;
  static const int MEDIUM_INT = WebGL.RenderingContext.MEDIUM_INT;
  static const int MEDIUM_FLOAT = WebGL.RenderingContext.MEDIUM_FLOAT;
  static const int HIGH_INT = WebGL.RenderingContext.HIGH_INT;
  static const int HIGH_FLOAT = WebGL.RenderingContext.HIGH_FLOAT;
}

class ShaderType {
  static const int FRAGMENT_SHADER = WebGL.RenderingContext.FRAGMENT_SHADER;
  static const int VERTEX_SHADER = WebGL.RenderingContext.VERTEX_SHADER;
}

class ShaderParameters {
  static const int DELETE_STATUS = WebGL.RenderingContext.DELETE_STATUS;
  static const int COMPILE_STATUS = WebGL.RenderingContext.COMPILE_STATUS;
  static const int SHADER_TYPE = WebGL.RenderingContext.SHADER_TYPE;
}

class VertexAttribGlEnum {
  static const int VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;
  static const int VERTEX_ATTRIB_ARRAY_ENABLED = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED;
  static const int VERTEX_ATTRIB_ARRAY_SIZE = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE;
  static const int VERTEX_ATTRIB_ARRAY_STRIDE = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE;
  static const int VERTEX_ATTRIB_ARRAY_TYPE = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE;
  static const int VERTEX_ATTRIB_ARRAY_NORMALIZED = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED;
  static const int VERTEX_ATTRIB_ARRAY_POINTER = WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER;
  static const int CURRENT_VERTEX_ATTRIB = WebGL.RenderingContext.CURRENT_VERTEX_ATTRIB;
}
