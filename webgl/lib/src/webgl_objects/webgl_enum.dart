import 'dart:mirrors';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/webgl_objects/webgl_active_info.dart';

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
  
  static WebGLEnum findTypeByIndex(Type GLEnum, int enumIndex) {
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


//WebGLRenderBuffers


class RenderBufferParameters extends WebGLEnum{

  const RenderBufferParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(RenderBufferParameters, index);

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
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(RenderBufferTarget, index);

  static const RenderBufferTarget RENDERBUFFER = const RenderBufferTarget(WebGL.RenderingContext.RENDERBUFFER,'RENDERBUFFER');
}

class RenderBufferInternalFormatType extends WebGLEnum{

  const RenderBufferInternalFormatType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(RenderBufferInternalFormatType, index);

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
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(FrameBufferStatus, index);

  static const FrameBufferStatus FRAMEBUFFER_COMPLETE = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_COMPLETE, 'FRAMEBUFFER_COMPLETE');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT, 'FRAMEBUFFER_INCOMPLETE_ATTACHMENT');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT, 'FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT');
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_DIMENSIONS = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS, 'FRAMEBUFFER_INCOMPLETE_DIMENSIONS');
  static const FrameBufferStatus FRAMEBUFFER_UNSUPPORTED = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_UNSUPPORTED, 'FRAMEBUFFER_UNSUPPORTED');
}

class FrameBufferTarget extends WebGLEnum{

  const FrameBufferTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(FrameBufferTarget, index);

  static const FrameBufferTarget FRAMEBUFFER = const FrameBufferTarget(WebGL.RenderingContext.FRAMEBUFFER, 'FRAMEBUFFER');
}

class FrameBufferAttachment extends WebGLEnum{

  const FrameBufferAttachment(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(FrameBufferAttachment, index);

  static const FrameBufferAttachment COLOR_ATTACHMENT0 = const FrameBufferAttachment(WebGL.RenderingContext.COLOR_ATTACHMENT0, 'COLOR_ATTACHMENT0');
  static const FrameBufferAttachment DEPTH_ATTACHMENT = const FrameBufferAttachment(WebGL.RenderingContext.DEPTH_ATTACHMENT, 'DEPTH_ATTACHMENT');
  static const FrameBufferAttachment STENCIL_ATTACHMENT = const FrameBufferAttachment(WebGL.RenderingContext.STENCIL_ATTACHMENT, 'STENCIL_ATTACHMENT');
}

class FrameBufferAttachmentType extends WebGLEnum{

  const FrameBufferAttachmentType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(FrameBufferAttachmentType, index);

  static const FrameBufferAttachmentType TEXTURE = const FrameBufferAttachmentType(WebGL.RenderingContext.TEXTURE, 'TEXTURE');
  static const FrameBufferAttachmentType RENDERBUFFER = const FrameBufferAttachmentType(WebGL.RenderingContext.RENDERBUFFER, 'RENDERBUFFER');
  static const FrameBufferAttachmentType NONE = const FrameBufferAttachmentType(WebGL.RenderingContext.NONE, 'NONE');
}

class FrameBufferAttachmentParameters extends WebGLEnum{

  const FrameBufferAttachmentParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(FrameBufferAttachmentParameters, index);

  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE, 'FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE');
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME, 'FRAMEBUFFER_ATTACHMENT_OBJECT_NAME');
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL, 'FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL');
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE, 'FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE');
}

class TextureAttachmentTarget extends WebGLEnum{

  const TextureAttachmentTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureAttachmentTarget, index);

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
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(BufferType, index);

  static const BufferType ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ARRAY_BUFFER, 'ARRAY_BUFFER');
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, 'ELEMENT_ARRAY_BUFFER');
}

class BufferUsageType extends WebGLEnum{

  const BufferUsageType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(BufferUsageType, index);

  static const BufferUsageType STATIC_DRAW =
  const BufferUsageType(WebGL.RenderingContext.STATIC_DRAW, 'STATIC_DRAW');
  static const BufferUsageType DYNAMIC_DRAW =
  const BufferUsageType(WebGL.RenderingContext.DYNAMIC_DRAW, 'DYNAMIC_DRAW');
  static const BufferUsageType STREAM_DRAW =
  const BufferUsageType(WebGL.RenderingContext.STREAM_DRAW, 'STREAM_DRAW');
}

class BufferParameters extends WebGLEnum{

  const BufferParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(BufferParameters, index);

  static const BufferParameters BUFFER_SIZE = const BufferParameters(WebGL.RenderingContext.BUFFER_SIZE, 'BUFFER_SIZE');
  static const BufferParameters BUFFER_USAGE = const BufferParameters(WebGL.RenderingContext.BUFFER_USAGE, 'BUFFER_USAGE');
}


//WebGLPrograms


class ProgramParameterGlEnum extends WebGLEnum{

  const ProgramParameterGlEnum(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(ProgramParameterGlEnum, index);

  static const ProgramParameterGlEnum DELETE_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.DELETE_STATUS, 'DELETE_STATUS');
  static const ProgramParameterGlEnum LINK_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.LINK_STATUS, 'LINK_STATUS');
  static const ProgramParameterGlEnum VALIDATE_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.VALIDATE_STATUS, 'VALIDATE_STATUS');
  static const ProgramParameterGlEnum ATTACHED_SHADERS = const ProgramParameterGlEnum(WebGL.RenderingContext.ATTACHED_SHADERS, 'ATTACHED_SHADERS');
  static const ProgramParameterGlEnum ACTIVE_ATTRIBUTES = const ProgramParameterGlEnum(WebGL.RenderingContext.ACTIVE_ATTRIBUTES, 'ACTIVE_ATTRIBUTES');
  static const ProgramParameterGlEnum ACTIVE_UNIFORMS = const ProgramParameterGlEnum(WebGL.RenderingContext.ACTIVE_UNIFORMS, 'ACTIVE_UNIFORMS');
}

class ProgramInfo{
  List<WebGLActiveInfo> attributes = new List();
  List<WebGLActiveInfo> uniforms = new List();
  int attributeCount = 0;
  int uniformCount = 0;
}


//WebGLTextures


class TextureParameterGlEnum extends WebGLEnum{

  const TextureParameterGlEnum(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureParameterGlEnum, index);

  static const TextureParameterGlEnum TEXTURE_MAG_FILTER =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_MAG_FILTER, 'TEXTURE_MAG_FILTER');
  static const TextureParameterGlEnum TEXTURE_MIN_FILTER =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_MIN_FILTER, 'TEXTURE_MIN_FILTER');
  static const TextureParameterGlEnum TEXTURE_WRAP_S =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_WRAP_S, 'TEXTURE_WRAP_S');
  static const TextureParameterGlEnum TEXTURE_WRAP_T =
  const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_WRAP_T, 'TEXTURE_WRAP_T');
//todo add if extension ?
}

class TextureTarget extends WebGLEnum{

  const TextureTarget(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureTarget, index);

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
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureMagType, index);

  static const TextureMagType LINEAR =
  const TextureMagType(WebGL.RenderingContext.LINEAR,'LINEAR');
  static const TextureMagType NEAREST =
  const TextureMagType(WebGL.RenderingContext.NEAREST,'NEAREST');
}

class TextureMinType extends TextureFilterType {
  const TextureMinType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureMinType, index);

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

class TextureInternalFormatType extends WebGLEnum{

  const TextureInternalFormatType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureInternalFormatType, index);

  static const TextureInternalFormatType ALPHA = const TextureInternalFormatType(WebGL.RenderingContext.ALPHA, 'ALPHA');
  static const TextureInternalFormatType RGB = const TextureInternalFormatType(WebGL.RenderingContext.RGB, 'RGB');
  static const TextureInternalFormatType RGBA = const TextureInternalFormatType(WebGL.RenderingContext.RGBA, 'RGBA');
  static const TextureInternalFormatType LUMINANCE = const TextureInternalFormatType(WebGL.RenderingContext.LUMINANCE, 'LUMINANCE');
  static const TextureInternalFormatType LUMINANCE_ALPHA = const TextureInternalFormatType(WebGL.RenderingContext.LUMINANCE_ALPHA, 'LUMINANCE_ALPHA');
}

//Todo move in extension
class WEBGL_depth_texture_InternalFormatType extends TextureInternalFormatType{
  const WEBGL_depth_texture_InternalFormatType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(WEBGL_depth_texture_InternalFormatType, index);

  static const WEBGL_depth_texture_InternalFormatType DEPTH_COMPONENT = const WEBGL_depth_texture_InternalFormatType(WebGL.RenderingContext.DEPTH_COMPONENT,'DEPTH_COMPONENT');
  static const WEBGL_depth_texture_InternalFormatType DEPTH_STENCIL = const WEBGL_depth_texture_InternalFormatType(WebGL.RenderingContext.DEPTH_STENCIL,'DEPTH_STENCIL');
}

class TextureWrapType extends TextureSetParameterType{
  const TextureWrapType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureWrapType, index);

  static const TextureWrapType REPEAT =
  const TextureWrapType(WebGL.RenderingContext.REPEAT, 'REPEAT');
  static const TextureWrapType CLAMP_TO_EDGE =
  const TextureWrapType(WebGL.RenderingContext.CLAMP_TO_EDGE, 'CLAMP_TO_EDGE');
  static const TextureWrapType MIRRORED_REPEAT =
  const TextureWrapType(WebGL.RenderingContext.MIRRORED_REPEAT, 'MIRRORED_REPEAT');
}

class TexelDataType extends WebGLEnum{

  const TexelDataType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TexelDataType, index);

  static const TexelDataType UNSIGNED_BYTE = const TexelDataType(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static const TexelDataType UNSIGNED_SHORT_5_6_5 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5, 'UNSIGNED_SHORT_5_6_5');
  static const TexelDataType UNSIGNED_SHORT_4_4_4_4 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4, 'UNSIGNED_SHORT_4_4_4_4');
  static const TexelDataType UNSIGNED_SHORT_5_5_5_1 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1, 'UNSIGNED_SHORT_5_5_5_1');
}

class TextureUnit extends WebGLEnum{

  const TextureUnit(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(TextureUnit, index);

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
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(ShaderVariableType, index);

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

  //Todo : remove this
  // Taken from the WebGL spec:
  // http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14
  static Map enumTypes = {
    0x8B50: ShaderVariableType.FLOAT_VEC2,
    0x8B51: ShaderVariableType.FLOAT_VEC3,
    0x8B52: ShaderVariableType.FLOAT_VEC4,
    0x8B53: ShaderVariableType.INT_VEC2,
    0x8B54: ShaderVariableType.INT_VEC3,
    0x8B55: ShaderVariableType.INT_VEC4,
    0x8B56: ShaderVariableType.BOOL,
    0x8B57: ShaderVariableType.BOOL_VEC2,
    0x8B58: ShaderVariableType.BOOL_VEC3,
    0x8B59: ShaderVariableType.BOOL_VEC4,
    0x8B5A: ShaderVariableType.FLOAT_MAT2,
    0x8B5B: ShaderVariableType.FLOAT_MAT3,
    0x8B5C: ShaderVariableType.FLOAT_MAT4,
    0x8B5E: ShaderVariableType.SAMPLER_2D,
    0x8B60: ShaderVariableType.SAMPLER_CUBE,
    0x1400: ShaderVariableType.BYTE,
    0x1401: ShaderVariableType.UNSIGNED_BYTE,
    0x1402: ShaderVariableType.SHORT,
    0x1403: ShaderVariableType.UNSIGNED_SHORT,
    0x1404: ShaderVariableType.INT,
    0x1405: ShaderVariableType.UNSIGNED_INT,
    0x1406: ShaderVariableType.FLOAT
  };
}

class PrecisionType extends WebGLEnum{

  const PrecisionType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(PrecisionType, index);

  static const PrecisionType LOW_INT = const PrecisionType(WebGL.RenderingContext.LOW_INT, 'LOW_INT');
  static const PrecisionType LOW_FLOAT = const PrecisionType(WebGL.RenderingContext.LOW_FLOAT, 'LOW_FLOAT');
  static const PrecisionType MEDIUM_INT = const PrecisionType(WebGL.RenderingContext.MEDIUM_INT, 'MEDIUM_INT');
  static const PrecisionType MEDIUM_FLOAT = const PrecisionType(WebGL.RenderingContext.MEDIUM_FLOAT, 'MEDIUM_FLOAT');
  static const PrecisionType HIGH_INT = const PrecisionType(WebGL.RenderingContext.HIGH_INT, 'HIGH_INT');
  static const PrecisionType HIGH_FLOAT = const PrecisionType(WebGL.RenderingContext.HIGH_FLOAT, 'HIGH_FLOAT');
}

class ShaderType extends WebGLEnum{

  const ShaderType(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(ShaderType, index);

  static const ShaderType FRAGMENT_SHADER = const ShaderType(WebGL.RenderingContext.FRAGMENT_SHADER, 'FRAGMENT_SHADER');
  static const ShaderType VERTEX_SHADER = const ShaderType(WebGL.RenderingContext.VERTEX_SHADER, 'VERTEX_SHADER');
}

class ShaderParameters extends WebGLEnum{

  const ShaderParameters(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(ShaderParameters, index);

  static const ShaderParameters DELETE_STATUS = const ShaderParameters(WebGL.RenderingContext.DELETE_STATUS, 'DELETE_STATUS');
  static const ShaderParameters COMPILE_STATUS = const ShaderParameters(WebGL.RenderingContext.COMPILE_STATUS, 'COMPILE_STATUS');
  static const ShaderParameters SHADER_TYPE = const ShaderParameters(WebGL.RenderingContext.SHADER_TYPE, 'SHADER_TYPE');
}

class VertexAttribGlEnum extends WebGLEnum{

  const VertexAttribGlEnum(int index, String name):super(index, name);
  static WebGLEnum getByIndex(int index) => WebGLEnum.findTypeByIndex(VertexAttribGlEnum, index);

  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,'VERTEX_ATTRIB_ARRAY_BUFFER_BINDING');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_ENABLED = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED, 'VERTEX_ATTRIB_ARRAY_ENABLED');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_SIZE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE, 'VERTEX_ATTRIB_ARRAY_SIZE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_STRIDE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE, 'VERTEX_ATTRIB_ARRAY_STRIDE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_TYPE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE, 'VERTEX_ATTRIB_ARRAY_TYPE');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_NORMALIZED = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED, 'VERTEX_ATTRIB_ARRAY_NORMALIZED');
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_POINTER = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER, 'VERTEX_ATTRIB_ARRAY_POINTER');
  static const VertexAttribGlEnum CURRENT_VERTEX_ATTRIB = const VertexAttribGlEnum(WebGL.RenderingContext.CURRENT_VERTEX_ATTRIB, 'CURRENT_VERTEX_ATTRIB');
}

