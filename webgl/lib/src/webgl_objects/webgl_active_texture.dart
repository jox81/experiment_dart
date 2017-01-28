import 'dart:html';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';
import 'dart:web_gl' as WebGL;
import 'dart:typed_data' as WebGlTypedData;
@MirrorsUsed(
    targets: const [
      ActiveTexture,
      EditTexture,
      Texture,
      Texture2D,
      TextureCubeMap
    ],
    override: '*')
import 'dart:mirrors';

class ActiveTexture extends IEditElement{

  static ActiveTexture _instance;
  ActiveTexture._init();

  static ActiveTexture get instance {
    if(_instance == null){
      _instance = new ActiveTexture._init();
    }
    return _instance;
  }

   // > MAX_TEXTURE_IMAGE_UNITS
  int get maxTextureImageUnits => gl.ctx.getParameter(ContextParameter.MAX_TEXTURE_IMAGE_UNITS.index);
  // > MAX_COMBINED_TEXTURE_IMAGE_UNITS
  int get maxCombinedTextureImageUnits => gl.ctx.getParameter(ContextParameter.MAX_COMBINED_TEXTURE_IMAGE_UNITS.index);
  // > MAX_CUBE_MAP_TEXTURE_SIZE
  int get maxCubeMapTextureSize => gl.ctx.getParameter(ContextParameter.MAX_CUBE_MAP_TEXTURE_SIZE.index);
  // > MAX_TEXTURE_SIZE
  int get maxTextureSize => gl.ctx.getParameter(ContextParameter.MAX_TEXTURE_SIZE.index);

  // > ACTIVE_TEXTURE
  TextureUnit get activeUnit => TextureUnit.getByIndex(gl.ctx.getParameter(ContextParameter.ACTIVE_TEXTURE.index));
  set activeUnit(TextureUnit textureUnit) {
    gl.ctx.activeTexture(textureUnit.index);
  }

  // >> Binding

  void bind(WebGLTexture texture, TextureTarget textureTarget) {
    gl.ctx.bindTexture(textureTarget.index, texture.webGLTexture);
  }

  Texture2D get texture2d => Texture2D.instance;
  TextureCubeMap get textureCubeMap => TextureCubeMap.instance;

  // > GENERATE_MIPMAP_HINT
  HintMode get mipMapHint => HintMode.getByIndex(gl.ctx.getParameter(ContextParameter.GENERATE_MIPMAP_HINT.index));
  set mipMapHint(HintMode mode) => gl.ctx.hint(ContextParameter.GENERATE_MIPMAP_HINT.index, mode.index);

  bool get unpackFlipYWebGL => gl.ctx.getParameter(ContextParameter.UNPACK_FLIP_Y_WEBGL.index);
  set unpackFlipYWebGL(bool flip) => gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, flip?1:0);

  // >>> Filling Texture

  void texImage2DWithWidthAndHeight(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormat internalFormat, int width, int height, int border, TextureInternalFormat internalFormat2, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(internalFormat.index == internalFormat2.index);//in webgl1

    gl.ctx.texImage2D(target.index, mipMapLevel, internalFormat.index, width, height, border, internalFormat2.index, texelDataType.index, pixels);
  }

  void texImage2D(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormat internalFormat, TextureInternalFormat internalFormat2, TexelDataType texelDataType, pixels) {
    assert(internalFormat.index == internalFormat2.index);//in webgl1
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.ctx.texImage2D(target.index, mipMapLevel, internalFormat.index, internalFormat2.index, texelDataType.index, pixels);
  }

  void texSubImage2DWithWidthAndHeight(TextureAttachmentTarget target, int mipMapLevel, int xOffset, int yOffset, int width, int height, TextureInternalFormat internalFormat, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.ctx.texSubImage2D(target.index, mipMapLevel, xOffset, yOffset, width, height, internalFormat.index, texelDataType.index, pixels);
  }

  void texSubImage2D(TextureAttachmentTarget target, int mipMapLevel, int xOffset, int yOffset, TextureInternalFormat internalFormat, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.ctx.texSubImage2D(target.index, mipMapLevel, xOffset, yOffset, internalFormat.index, texelDataType.index, pixels);
  }

  void copyTexImage2D(TextureAttachmentTarget target, int mipMapLevel, TextureInternalFormat internalFormat,
      int x, int y, int width, int height, pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    assert(width >= 0);
    assert(height >= 0);
    gl.ctx.copyTexImage2D(target.index, mipMapLevel, internalFormat.index, x, y, width, height, pixels);
  }

  ///Copies pixels from the current WebGLFramebuffer into an existing 2D texture sub-image.
  void copyTexSubImage2D(TextureAttachmentTarget target, int mipMapLevel, int xOffset, int yOffset,
      int x, int y, int width, int height) {
    assert(width >= 0);
    assert(height >= 0);
    gl.ctx.copyTexSubImage2D(target.index, mipMapLevel, xOffset, yOffset, x, y, width, height);
  }

  // > Logging

  void logTextureUnitInfo(TextureUnit textureUnit){
    Utils.log('ActiveTexture', (){
      TextureUnit lastTextureUnit = _instance.activeUnit;

      _instance.activeUnit = textureUnit;

      logActiveTextureInfo();

      _instance.activeUnit = lastTextureUnit;
    });
  }

  void logActiveTextureInfo(){
    Utils.log('ActiveTexture', (){
      print('maxTextureImageUnits : ${maxTextureImageUnits}');
      print('maxCombinedTextureImageUnits : ${maxCombinedTextureImageUnits}');
      print('maxCubeMapTextureSize : ${maxCubeMapTextureSize}');
      print('maxTextureSize : ${maxTextureSize}');
      print('generateMipMapHint : ${mipMapHint}');

      print('### texture bindings #############################################');
      print('activeUnit : ${_instance.activeUnit}');
      if(texture2d.boundTexture != null) {
        print('### texture2D binding ............................................');
        print('boundTexture2D : ${texture2d.boundTexture}');
        print('getTextureMagFilter : ${texture2d.textureMagFilter}');//
        print('getTextureMinFilter : ${texture2d.textureMinFilter}');
        print('getTextureWrapS : ${texture2d.textureWrapS}');
        print('getTextureWrapT : ${texture2d.textureWrapT}');
      }else{
        print('### no texture2D bound');
      }
      if(textureCubeMap.boundTexture != null) {
        print('### textureCubeMap binding .......................................');
        print('boundTextureCubeMap : ${textureCubeMap.boundTexture}');
        print('getTextureMagFilter : ${textureCubeMap.textureMagFilter}');//
        print('getTextureMinFilter : ${textureCubeMap.textureMinFilter}');
        print('getTextureWrapS : ${textureCubeMap.textureWrapS}');
        print('getTextureWrapT : ${textureCubeMap.textureWrapT}');
      }else{
        print('### no textureCubeMap bound');
      }
    });
  }
}

abstract class Texture{
  TextureTarget textureTarget;

  // > Bindings

  // > TEXTURE_BINDING
  WebGLTexture get boundTexture {
    assert(textureTarget == TextureTarget.TEXTURE_2D || textureTarget == TextureTarget.TEXTURE_CUBE_MAP);

    ContextParameter textureBinding = textureTarget == TextureTarget.TEXTURE_2D ? ContextParameter.TEXTURE_BINDING_2D : ContextParameter.TEXTURE_BINDING_CUBE_MAP;

    WebGL.Texture webGLTexture = gl.ctx.getParameter(textureBinding.index);
    if(webGLTexture != null && gl.ctx.isTexture(webGLTexture)){
      return new WebGLTexture.fromWebGL(webGLTexture, TextureTarget.getByIndex(textureBinding.index));
    }
    return null;
  }

  // > MipMap
  void generateMipmap(){
    gl.ctx.generateMipmap(textureTarget.index);
  }

  // >> Binding

  void bind(WebGLTexture texture) {
    gl.ctx.bindTexture(textureTarget.index, texture?.webGLTexture);
  }
  void unBind() {
    gl.ctx.bindTexture(textureTarget.index, null);
  }

  // >>> single getParameter

  // > TEXTURE_MAG_FILTER
  TextureMagnificationFilterType get textureMagFilter{
    return TextureMagnificationFilterType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_MAG_FILTER.index));
  }
  set textureMagFilter(TextureMagnificationFilterType  textureMagnificationFilterType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_MAG_FILTER.index, textureMagnificationFilterType.index);
  }

  // > TEXTURE_MIN_FILTER
  TextureMinificationFilterType get textureMinFilter {
    return TextureMinificationFilterType.getByIndex(gl.ctx.getTexParameter(
        textureTarget.index,
        TextureParameter.TEXTURE_MIN_FILTER.index));
  }
  set textureMinFilter(TextureMinificationFilterType  textureMinificationFilterType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_MIN_FILTER.index, textureMinificationFilterType.index);
  }

  // > TEXTURE_WRAP_S
  TextureWrapType get textureWrapS
  {
    return TextureWrapType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_WRAP_S.index));
  }
  set textureWrapS(TextureWrapType  textureWrapType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_WRAP_S.index, textureWrapType.index);
  }

  // > TEXTURE_WRAP_T
  TextureWrapType get textureWrapT {
    return TextureWrapType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_WRAP_T.index));
  }
  set textureWrapT(TextureWrapType  textureWrapType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_WRAP_T.index, textureWrapType.index);
  }

  // >> Set values
  void setParameterFloat(TextureParameter parameter, num value) {
    gl.ctx.texParameterf(textureTarget.index, parameter.index, value);
  }

  void setParameterInt(TextureParameter parameter, TextureSetParameterType value) {
    gl.ctx.texParameteri(textureTarget.index, parameter.index, value.index);
  }

  // >>> Parameters

  dynamic getParameter(TextureParameter parameter) {
    dynamic result =
    gl.ctx.getTexParameter(textureTarget.index, parameter.index);
    return result;
  }

  void logInfo(){
    Utils.log('ActiveTexture', (){
      print('### texture bindings #############################################');
      print('activeUnit : ${ActiveTexture.instance.activeUnit}');
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

class Texture2D extends Texture{
  TextureTarget textureTarget = TextureTarget.TEXTURE_2D;

  static Texture2D _instance;
  Texture2D._init();

  static Texture2D get instance {
    if(_instance == null){
      _instance = new Texture2D._init();
    }
    return _instance;
  }
}

class TextureCubeMap extends Texture{
  TextureTarget textureTarget = TextureTarget.TEXTURE_CUBE_MAP;

  static TextureCubeMap _instance;
  TextureCubeMap._init();

  static TextureCubeMap get instance {
    if(_instance == null){
      _instance = new TextureCubeMap._init();
    }
    return _instance;
  }
}