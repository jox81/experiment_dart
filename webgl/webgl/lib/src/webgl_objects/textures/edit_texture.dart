import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

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
