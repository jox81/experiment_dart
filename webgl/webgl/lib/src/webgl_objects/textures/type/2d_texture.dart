import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/textures/texture.dart';
import 'package:webgl/src/webgl_objects/textures/type/attachment_texture.dart';

class Texture2D extends Texture{

  static Texture2D _instance;
  static Texture2D get instance {
    if(_instance == null){
      _instance = new Texture2D._init();
    }
    return _instance;
  }

  int textureTarget = TextureTarget.TEXTURE_2D;

  Texture2D._init(){
    _attachments[0] = new TextureAttachment(TextureAttachmentTarget.TEXTURE_2D);
  }

  List<TextureAttachment> _attachments = new List(1);

  List<TextureAttachment> get attachments => [
    attachmentTexture2d,
  ];

  TextureAttachment get attachmentTexture2d {
    return _attachments[0];
  }
}