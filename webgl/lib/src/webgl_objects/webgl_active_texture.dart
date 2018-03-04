import 'dart:html';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/debug/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';
import 'dart:web_gl' as WebGL;
import 'dart:typed_data' as WebGlTypedData;
//@MirrorsUsed(
//    targets: const [
//      ActiveTexture,
//      EditTexture,
//      Texture,
//      Texture2D,
//      TextureCubeMap
//    ],
//    override: '*')
//import 'dart:mirrors';

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
  int get maxTextureImageUnits => gl.getParameter(ContextParameter.MAX_TEXTURE_IMAGE_UNITS) as int;
  // > MAX_COMBINED_TEXTURE_IMAGE_UNITS
  int get maxCombinedTextureImageUnits => gl.getParameter(ContextParameter.MAX_COMBINED_TEXTURE_IMAGE_UNITS) as int ;
  // > MAX_CUBE_MAP_TEXTURE_SIZE
  int get maxCubeMapTextureSize => gl.getParameter(ContextParameter.MAX_CUBE_MAP_TEXTURE_SIZE) as int;
  // > MAX_TEXTURE_SIZE
  int get maxTextureSize => gl.getParameter(ContextParameter.MAX_TEXTURE_SIZE)as int;

  // > ACTIVE_TEXTURE
  /// TextureUnit get activeTexture
  int get activeTexture => gl.getParameter(ContextParameter.ACTIVE_TEXTURE)as int;
  /// TextureUnit textureUnit
  set activeTexture(int textureUnit) {
    gl.activeTexture(textureUnit);
  }

  // >> Binding

  /// TextureTarget textureTarget
  void bindTexture(int textureTarget, WebGL.Texture texture) {
    gl.bindTexture(textureTarget, texture);
  }

  Texture2D get texture2d => Texture2D.instance;
  TextureCubeMap get textureCubeMap => TextureCubeMap.instance;

  // > GENERATE_MIPMAP_HINT
  ///mipMapHint HintMode mode
  int get hint => gl.getParameter(ContextParameter.GENERATE_MIPMAP_HINT)as int;
  set hint(int mode) => gl.hint(ContextParameter.GENERATE_MIPMAP_HINT, mode);

  bool get unpackFlipYWebGL => gl.getParameter(ContextParameter.UNPACK_FLIP_Y_WEBGL)as bool;
  set unpackFlipYWebGL(bool flip) => gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, flip?1:0);

  // > Logging

  /// TextureUnit textureUnit
  void logTextureUnitInfo(int textureUnit){
    Debug.log('ActiveTexture', (){
      int lastTextureUnit = _instance.activeTexture;

      _instance.activeTexture = textureUnit;

      logActiveTextureInfo();

      _instance.activeTexture = lastTextureUnit;
    });
  }

  void logActiveTextureInfo(){
    Debug.log('ActiveTexture', (){
      print('maxTextureImageUnits : ${maxTextureImageUnits}');
      print('maxCombinedTextureImageUnits : ${maxCombinedTextureImageUnits}');
      print('maxCubeMapTextureSize : ${maxCubeMapTextureSize}');
      print('maxTextureSize : ${maxTextureSize}');
      print('generateMipMapHint : ${hint}');

      print('### texture bindings #############################################');
      print('activeUnit : ${_instance.activeTexture}');
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

class TextureAttachment{

  TextureAttachment(this.textureAttachmentTarget);

  /// TextureAttachmentTarget textureAttachmentTarget;
  final int textureAttachmentTarget;

  // >>> Filling Texture

  /// TextureInternalFormat internalFormat
  /// TextureInternalFormat internalFormat2
  /// TexelDataType texelDataType
  void texImage2DWithWidthAndHeight(int mipMapLevel, int internalFormat, int width, int height, int border, int internalFormat2, int texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(internalFormat == internalFormat2);//in webgl1

    gl.texImage2D(textureAttachmentTarget, mipMapLevel, internalFormat, width, height, border, internalFormat2, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  /// TextureInternalFormat internalFormat2
  /// TexelDataType texelDataType
  void texImage2D(int mipMapLevel, int internalFormat, int internalFormat2, int texelDataType, dynamic pixels) {
    assert(internalFormat == internalFormat2);//in webgl1
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap || pixels == null); //? add is null
    gl.texImage2D(textureAttachmentTarget, mipMapLevel, internalFormat, internalFormat2, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  /// TexelDataType texelDataType
  void texSubImage2DWithWidthAndHeight(int mipMapLevel, int xOffset, int yOffset, int width, int height, int internalFormat, int texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.texSubImage2D(textureAttachmentTarget, mipMapLevel, xOffset, yOffset, width, height, internalFormat, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  /// TexelDataType texelDataType
  void texSubImage2D(int mipMapLevel, int xOffset, int yOffset, int internalFormat, int texelDataType, WebGlTypedData.TypedData pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.texSubImage2D(textureAttachmentTarget, mipMapLevel, xOffset, yOffset, internalFormat, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  void copyTexImage2D(int mipMapLevel, int internalFormat,
      int x, int y, int width, int height, int border) {
    assert(width >= 0);
    assert(height >= 0);
    gl.copyTexImage2D(textureAttachmentTarget, mipMapLevel, internalFormat, x, y, width, height, border);
  }

  ///Copies pixels from the current WebGLFramebuffer into an existing 2D texture sub-image.
  void copyTexSubImage2D(int mipMapLevel, int xOffset, int yOffset,
      int x, int y, int width, int height) {
    assert(width >= 0);
    assert(height >= 0);
    gl.copyTexSubImage2D(textureAttachmentTarget, mipMapLevel, xOffset, yOffset, x, y, width, height);
  }

}