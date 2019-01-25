import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/textures/texture.dart';
import 'package:webgl/src/webgl_objects/textures/type/attachment_texture.dart';

class TextureCubeMap extends Texture{

  static TextureCubeMap _instance;
  static TextureCubeMap get instance {
    if(_instance == null){
      _instance = new TextureCubeMap._init();
    }
    return _instance;
  }

  int textureTarget = TextureTarget.TEXTURE_CUBE_MAP;

  TextureCubeMap._init(){
    _attachments[0] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_CUBE_MAP_POSITIVE_X);
    _attachments[1] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_CUBE_MAP_NEGATIVE_X);
    _attachments[2] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_CUBE_MAP_POSITIVE_Y);
    _attachments[3] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_CUBE_MAP_NEGATIVE_Y);
    _attachments[4] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_CUBE_MAP_POSITIVE_Z);
    _attachments[5] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_CUBE_MAP_NEGATIVE_Z);
  }

  List<TextureAttachment> _attachments = new List(6);

  List<TextureAttachment> get attachments => [
    attachmentPositiveX,
    attachmentNegativeX,
    attachmentPositiveY,
    attachmentNegativeY,
    attachmentPositiveZ,
    attachmentNegativeZ,
  ];

  TextureAttachment get attachmentPositiveX {
    return _attachments[0];
  }

  TextureAttachment get attachmentNegativeX {
    return _attachments[1];
  }

  TextureAttachment get attachmentPositiveY {
    return _attachments[2];
  }

  TextureAttachment get attachmentNegativeY {
    return _attachments[3];
  }

  TextureAttachment get attachmentPositiveZ {
    return _attachments[4];
  }

  TextureAttachment get attachmentNegativeZ {
    return _attachments[5];
  }
}