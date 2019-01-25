import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';
import 'dart:web_gl' as WebGL;

abstract class Texture{
  /// TextureTarget textureTarget;
  int textureTarget;
  TextureAttachmentTarget textureAttachmentTarget;

  // > Bindings

  // > TEXTURE_BINDING
  WebGLTexture get boundTexture {
    assert(textureTarget == TextureTarget.TEXTURE_2D || textureTarget == TextureTarget.TEXTURE_CUBE_MAP);

    ///ContextParameter textureBinding
    int textureBinding = textureTarget == TextureTarget.TEXTURE_2D ? ContextParameter.TEXTURE_BINDING_2D : ContextParameter.TEXTURE_BINDING_CUBE_MAP;

    WebGL.Texture webGLTexture = gl.getParameter(textureBinding) as WebGL.Texture;
    if(webGLTexture != null && gl.isTexture(webGLTexture)){
      return new WebGLTexture.fromWebGL(webGLTexture, textureBinding);
    }
    return null;
  }

  // > MipMap
  void generateMipmap(){
    gl.generateMipmap(textureTarget);
  }

  // >> Binding

  void bind(WebGLTexture texture) {
    gl.bindTexture(textureTarget, texture?.webGLTexture);
  }
  void unBind() {
    gl.bindTexture(textureTarget, null);
  }

  // >>> single getParameter

  // > TEXTURE_MAG_FILTER
  /// TextureMagnificationFilterType get textureMagFilter{
  int get textureMagFilter{
    return gl.getTexParameter(textureTarget,TextureParameter.TEXTURE_MAG_FILTER)as int;
  }
  set textureMagFilter(int  textureMagnificationFilterType){
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_MAG_FILTER, textureMagnificationFilterType);
  }

  // > TEXTURE_MIN_FILTER
  /// TextureMinificationFilterType get textureMinFilter
  int get textureMinFilter {
    return gl.getTexParameter(
        textureTarget,
        TextureParameter.TEXTURE_MIN_FILTER)as int;
  }
  set textureMinFilter(int  textureMinificationFilterType){
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_MIN_FILTER, textureMinificationFilterType);
  }

  // > TEXTURE_WRAP_S
  /// TextureWrapType get textureWrapS
  int get textureWrapS
  {
    return gl.getTexParameter(textureTarget,TextureParameter.TEXTURE_WRAP_S)as int;
  }
  set textureWrapS(int  textureWrapType){
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_WRAP_S, textureWrapType);
  }

  // > TEXTURE_WRAP_T
  /// TextureWrapType get textureWrapT
  int get textureWrapT {
    return gl.getTexParameter(textureTarget,TextureParameter.TEXTURE_WRAP_T)as int;
  }
  set textureWrapT(int  textureWrapType){
    gl.texParameteri(textureTarget, TextureParameter.TEXTURE_WRAP_T, textureWrapType);
  }

  // >> Set values
  /// TextureParameter parameter
  void setParameterFloat(int parameter, num value) {
    gl.texParameterf(textureTarget, parameter, value);
  }

  /// TextureParameter parameter
  /// TextureSetParameterType value
  void setParameterInt(int parameter, int value) {
    gl.texParameteri(textureTarget, parameter, value);
  }

  // >>> Parameters

  /// TextureParameter parameter
  dynamic getParameter(int parameter) {
    dynamic result =
    gl.getTexParameter(textureTarget, parameter);
    return result;
  }

  void logInfo(){
    Debug.log('ActiveTexture', (){
      print('### texture bindings #############################################');
      print('activeUnit : ${ActiveTexture.instance.activeTexture}');
      if(boundTexture != null) {
        print('### texture binding ............................................');
        print('textureTarget : ${textureTarget}');
        print('boundTexture2D : ${boundTexture}');
        print('getTextureMagFilter : ${textureMagFilter}');//
        print('getTextureMinFilter : ${textureMinFilter}');
        print('getTextureWrapS : ${textureWrapS}');
        print('getTextureWrapT : ${textureWrapT}');
      }else{
        print('### no texture bound in $textureTarget');
      }
    });
  }
}