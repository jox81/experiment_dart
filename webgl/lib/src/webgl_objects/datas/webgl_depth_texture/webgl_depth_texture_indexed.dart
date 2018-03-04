import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/datas/webgl_enum_indexed.dart';
//@MirrorsUsed(
//    targets: const [
//      WEBGL_depth_texture_InternalFormat,
//      WEBGL_depth_texture_TexelDataType,
//      WEBGL_depth_texture_TextureAttachmentTarget,
//    ],
//    override: '*')
//import 'dart:mirrors';

//Extension : WEBGL_depth_texture
//From https://www.khronos.org/registry/webgl/extensions/WEBGL_depth_texture/
//!! This extension is only available to WebGL1 contexts.
// In WebGL2, the functionality of this extension is available on the WebGL2 context by default.
class WEBGL_depth_texture_InternalFormat extends TextureInternalFormat {
  static const int DEPTH_COMPONENT = WebGL.RenderingContext.DEPTH_COMPONENT;
  static const int DEPTH_STENCIL = WebGL.RenderingContext.DEPTH_STENCIL;
}

class WEBGL_depth_texture_TexelDataType extends TexelDataType {
  ///Unsigned integer type for 24-bit depth texture data.
  static const int UNSIGNED_INT_24_8_WEBGL = WebGL.DepthTexture.UNSIGNED_INT_24_8_WEBGL;
  static const int UNSIGNED_SHORT = WebGL.RenderingContext.UNSIGNED_SHORT;
  static const int UNSIGNED_INT = WebGL.RenderingContext.UNSIGNED_INT;
}

class WEBGL_depth_texture_TextureAttachmentTarget extends TextureAttachmentTarget {
  static const int DEPTH_ATTACHMENT = WebGL.RenderingContext.DEPTH_ATTACHMENT;
  static const int DEPTH_STENCIL_ATTACHMENT = WebGL.RenderingContext.DEPTH_STENCIL_ATTACHMENT;
}