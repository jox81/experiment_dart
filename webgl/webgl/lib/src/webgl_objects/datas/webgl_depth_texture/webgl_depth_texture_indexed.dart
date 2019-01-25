import 'dart:web_gl';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_indexed.dart';

//Extension : WEBGL_depth_texture
//From https://www.khronos.org/registry/webgl/extensions/WEBGL_depth_texture/
//!! This extension is only available to WebGL1 contexts.
// In WebGL2, the functionality of this extension is available on the WebGL2 context by default.
class WEBGL_depth_texture_InternalFormat extends TextureInternalFormat {
  static const int DEPTH_COMPONENT = WebGL.DEPTH_COMPONENT;
  static const int DEPTH_STENCIL = WebGL.DEPTH_STENCIL;
}

class WEBGL_depth_texture_TexelDataType extends TexelDataType {
  ///Unsigned integer type for 24-bit depth texture data.
  static const int UNSIGNED_INT_24_8_WEBGL = DepthTexture.UNSIGNED_INT_24_8_WEBGL;
  static const int UNSIGNED_SHORT = WebGL.UNSIGNED_SHORT;
  static const int UNSIGNED_INT = WebGL.UNSIGNED_INT;
}

class WEBGL_depth_texture_TextureAttachmentTarget extends TextureAttachmentTarget {
  static const int DEPTH_ATTACHMENT = WebGL.DEPTH_ATTACHMENT;
  static const int DEPTH_STENCIL_ATTACHMENT = WebGL.DEPTH_STENCIL_ATTACHMENT;
}