import 'dart:html';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/utils/utils_debug.dart';
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
  int get maxTextureImageUnits => gl.ctx.getParameter(ContextParameter.MAX_TEXTURE_IMAGE_UNITS.index) as int;
  // > MAX_COMBINED_TEXTURE_IMAGE_UNITS
  int get maxCombinedTextureImageUnits => gl.ctx.getParameter(ContextParameter.MAX_COMBINED_TEXTURE_IMAGE_UNITS.index) as int ;
  // > MAX_CUBE_MAP_TEXTURE_SIZE
  int get maxCubeMapTextureSize => gl.ctx.getParameter(ContextParameter.MAX_CUBE_MAP_TEXTURE_SIZE.index) as int;
  // > MAX_TEXTURE_SIZE
  int get maxTextureSize => gl.ctx.getParameter(ContextParameter.MAX_TEXTURE_SIZE.index)as int;

  // > ACTIVE_TEXTURE
  TextureUnit get activeUnit => TextureUnit.getByIndex(gl.ctx.getParameter(ContextParameter.ACTIVE_TEXTURE.index)as int);
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
  HintMode get mipMapHint => HintMode.getByIndex(gl.ctx.getParameter(ContextParameter.GENERATE_MIPMAP_HINT.index)as int);
  set mipMapHint(HintMode mode) => gl.ctx.hint(ContextParameter.GENERATE_MIPMAP_HINT.index, mode.index);

  bool get unpackFlipYWebGL => gl.ctx.getParameter(ContextParameter.UNPACK_FLIP_Y_WEBGL.index)as bool;
  set unpackFlipYWebGL(bool flip) => gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, flip?1:0);

  // > Logging

  void logTextureUnitInfo(TextureUnit textureUnit){
    Debug.log('ActiveTexture', (){
      TextureUnit lastTextureUnit = _instance.activeUnit;

      _instance.activeUnit = textureUnit;

      logActiveTextureInfo();

      _instance.activeUnit = lastTextureUnit;
    });
  }

  void logActiveTextureInfo(){
    Debug.log('ActiveTexture', (){
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
  TextureAttachmentTarget textureAttachmentTarget;

  // > Bindings

  // > TEXTURE_BINDING
  WebGLTexture get boundTexture {
    assert(textureTarget == TextureTarget.TEXTURE_2D || textureTarget == TextureTarget.TEXTURE_CUBE_MAP);

    ContextParameter textureBinding = textureTarget == TextureTarget.TEXTURE_2D ? ContextParameter.TEXTURE_BINDING_2D : ContextParameter.TEXTURE_BINDING_CUBE_MAP;

    WebGL.Texture webGLTexture = gl.ctx.getParameter(textureBinding.index) as WebGL.Texture;
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
    return TextureMagnificationFilterType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_MAG_FILTER.index)as int)as TextureMagnificationFilterType;
  }
  set textureMagFilter(TextureMagnificationFilterType  textureMagnificationFilterType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_MAG_FILTER.index, textureMagnificationFilterType.index);
  }

  // > TEXTURE_MIN_FILTER
  TextureMinificationFilterType get textureMinFilter {
    return TextureMinificationFilterType.getByIndex(gl.ctx.getTexParameter(
        textureTarget.index,
        TextureParameter.TEXTURE_MIN_FILTER.index)as int)as TextureMinificationFilterType;
  }
  set textureMinFilter(TextureMinificationFilterType  textureMinificationFilterType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_MIN_FILTER.index, textureMinificationFilterType.index);
  }

  // > TEXTURE_WRAP_S
  TextureWrapType get textureWrapS
  {
    return TextureWrapType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_WRAP_S.index)as int);
  }
  set textureWrapS(TextureWrapType  textureWrapType){
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_WRAP_S.index, textureWrapType.index);
  }

  // > TEXTURE_WRAP_T
  TextureWrapType get textureWrapT {
    return TextureWrapType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_WRAP_T.index)as int);
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
    Debug.log('ActiveTexture', (){
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

  static Texture2D _instance;
  static Texture2D get instance {
    if(_instance == null){
      _instance = new Texture2D._init();
    }
    return _instance;
  }

  TextureTarget textureTarget = TextureTarget.TEXTURE_2D;

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

class TextureCubeMap extends Texture{

  static TextureCubeMap _instance;
  static TextureCubeMap get instance {
    if(_instance == null){
      _instance = new TextureCubeMap._init();
    }
    return _instance;
  }

  TextureTarget textureTarget = TextureTarget.TEXTURE_CUBE_MAP;

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

class TextureAttachment{

  TextureAttachment(this.textureAttachmentTarget);

  final TextureAttachmentTarget textureAttachmentTarget;

  // >>> Filling Texture

  void texImage2DWithWidthAndHeight(int mipMapLevel, TextureInternalFormat internalFormat, int width, int height, int border, TextureInternalFormat internalFormat2, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(internalFormat.index == internalFormat2.index);//in webgl1

    gl.ctx.texImage2D(textureAttachmentTarget.index, mipMapLevel, internalFormat.index, width, height, border, internalFormat2.index, texelDataType.index, pixels);
  }

  void texImage2D(int mipMapLevel, TextureInternalFormat internalFormat, TextureInternalFormat internalFormat2, TexelDataType texelDataType, dynamic pixels) {
    assert(internalFormat.index == internalFormat2.index);//in webgl1
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap ); //? add is null
    gl.ctx.texImage2D(textureAttachmentTarget.index, mipMapLevel, internalFormat.index, internalFormat2.index, texelDataType.index, pixels);
  }

  void texSubImage2DWithWidthAndHeight(int mipMapLevel, int xOffset, int yOffset, int width, int height, TextureInternalFormat internalFormat, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.ctx.texSubImage2D(textureAttachmentTarget.index, mipMapLevel, xOffset, yOffset, width, height, internalFormat.index, texelDataType.index, pixels);
  }

  void texSubImage2D(int mipMapLevel, int xOffset, int yOffset, TextureInternalFormat internalFormat, TexelDataType texelDataType, WebGlTypedData.TypedData pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.ctx.texSubImage2D(textureAttachmentTarget.index, mipMapLevel, xOffset, yOffset, internalFormat.index, texelDataType.index, pixels);
  }

  void copyTexImage2D(int mipMapLevel, TextureInternalFormat internalFormat,
      int x, int y, int width, int height, int border) {
    assert(width >= 0);
    assert(height >= 0);
    gl.ctx.copyTexImage2D(textureAttachmentTarget.index, mipMapLevel, internalFormat.index, x, y, width, height, border);
  }

  ///Copies pixels from the current WebGLFramebuffer into an existing 2D texture sub-image.
  void copyTexSubImage2D(int mipMapLevel, int xOffset, int yOffset,
      int x, int y, int width, int height) {
    assert(width >= 0);
    assert(height >= 0);
    gl.ctx.copyTexSubImage2D(textureAttachmentTarget.index, mipMapLevel, xOffset, yOffset, x, y, width, height);
  }

}