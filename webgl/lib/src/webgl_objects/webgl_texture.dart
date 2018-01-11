import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/debug/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
@MirrorsUsed(targets: const [
  WebGLTexture,
], override: '*')
import 'dart:mirrors';

class WebGLTexture extends EditTexture {
  final WebGL.Texture webGLTexture;
  final int textureTarget;

  ImageElement _image;
  ImageElement get image => _image;
  set image(ImageElement value){
    _image = value;
//    if(value != null) {
//      _image.onClick.listen(null);
//      _image.onClick.listen((e) {
//
//      });
//    }
    _replaceImage(value);
  }

  Matrix4 textureMatrix = new Matrix4.identity();

  bool get isTexture => gl.isTexture(webGLTexture);

  WebGLTexture.texture2d() : this.textureTarget = TextureTarget.TEXTURE_2D, this.webGLTexture = gl.createTexture();
  WebGLTexture.textureCubeMap() : this.textureTarget = TextureTarget.TEXTURE_CUBE_MAP, this.webGLTexture = gl.createTexture();
  /// TextureTarget textureTarget
  WebGLTexture.fromWebGL(WebGL.Texture webGLTexture, int textureTarget): this.webGLTexture = webGLTexture, this.textureTarget = textureTarget;

  @override
  void delete() => gl.deleteTexture(webGLTexture);

  void logTextureInfos() {
    Debug.log("WebGLTexture Infos", () {

      print('editTextureUnit : ${editTextureUnit}');
      print('webGLTexture : ${webGLTexture}');
      print('textureTarget : ${textureTarget}');
      print('isTexture : ${isTexture}');

//      ActiveTexture.instance.activeUnit = editTextureUnit;
//
//      ActiveTexture.instance
//        ..texture2d.bind(this);

    });
  }

  @override
  void edit() {
    int lastTextureUnit = ActiveTexture.instance.activeTexture;

    ActiveTexture.instance.activeTexture = editTextureUnit;

    final v = textureTarget;
    switch(v){
      case TextureTarget.TEXTURE_2D:
        ActiveTexture.instance.texture2d.bind(this);
        break;
      case TextureTarget.TEXTURE_CUBE_MAP:
        ActiveTexture.instance.textureCubeMap.bind(this);
        break;
    }

    ActiveTexture.instance.activeTexture = lastTextureUnit;
  }

  void _replaceImage(ImageElement image) {
    int lastTextureUnit = ActiveTexture.instance.activeTexture;

    ActiveTexture.instance.activeTexture = editTextureUnit;

    Context.glWrapper.activeTexture.texture2d.bind(this);

    Context.glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2D(
        0,
        TextureInternalFormat.RGBA,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        image);

    Context.glWrapper.activeTexture.texture2d.unBind();

    ActiveTexture.instance.activeTexture = lastTextureUnit;
  }
}

abstract class EditTexture extends WebGLObject{

  int textureTarget;

  ///TextureUnit editTextureUnit;
  int editTextureUnit = TextureUnit.TEXTURE8;

  // >>> single getParameter

  // >> Bind

  /// TextureUnit textureUnit
  void bind({int textureUnit}) {
    if(textureUnit != null){
      Context.glWrapper.activeTexture.activeTexture = textureUnit;
    }
    Context.glWrapper.activeTexture.bindTexture(textureTarget, (this as WebGLTexture).webGLTexture);
  }

  // > TEXTURE_MAG_FILTER
  /// TextureMagnificationFilterType get textureMagFilter
  int get textureMagFilter{
    bind(textureUnit: editTextureUnit);
    return gl.getTexParameter(textureTarget,TextureParameter.TEXTURE_MAG_FILTER) as int;
  }
  set textureMagFilter(int textureMagnificationFilterType){
    bind(textureUnit: editTextureUnit);
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_MAG_FILTER, textureMagnificationFilterType);
  }

  // > TEXTURE_MIN_FILTER
  /// TextureMinificationFilterType get textureMinFilter
  int get textureMinFilter {
    bind(textureUnit: editTextureUnit);
    return gl.getTexParameter(
        textureTarget,
        TextureParameter.TEXTURE_MIN_FILTER) as int;
  }
  set textureMinFilter(int  textureMinificationFilterType){
    bind(textureUnit: editTextureUnit);
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_MIN_FILTER, textureMinificationFilterType);
  }

  // > TEXTURE_WRAP_S
  /// TextureWrapType get textureWrapS
  int get textureWrapS
  {
    bind(textureUnit: editTextureUnit);
    return gl.getTexParameter(textureTarget,TextureParameter.TEXTURE_WRAP_S) as int;
  }
  set textureWrapS(int  textureWrapType){
    bind(textureUnit: editTextureUnit);
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_WRAP_S, textureWrapType);
  }

  // > TEXTURE_WRAP_T
  /// TextureWrapType get textureWrapT
  int get textureWrapT {
    bind(textureUnit: editTextureUnit);
    return gl.getTexParameter(textureTarget,TextureParameter.TEXTURE_WRAP_T) as int;
  }
  set textureWrapT(int  textureWrapType){
    bind(textureUnit: editTextureUnit);
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_WRAP_T, textureWrapType);
  }

}
