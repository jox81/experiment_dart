import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';
import 'dart:web_gl' as WebGL;

class ActiveTexture{

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
  set activeUnit(TextureUnit textureUnit) => gl.ctx.activeTexture(textureUnit.index);

  // > MipMap
  void generateMipmap(TextureTarget target){
    gl.ctx.generateMipmap(target.index);
  }
  // > GENERATE_MIPMAP_HINT
  HintMode get generateMipMapHint => HintMode.getByIndex(gl.ctx.getParameter(ContextParameter.GENERATE_MIPMAP_HINT.index));
  void hint(HintMode mode){
    gl.ctx.hint(ContextParameter.GENERATE_MIPMAP_HINT.index, mode.index);
  }

  // > Bindings

  // > TEXTURE_BINDING_2D
  WebGLTexture get boundTexture2D {
    WebGL.Texture webGLTexture = gl.ctx.getParameter(ContextParameter.TEXTURE_BINDING_2D.index);
    if(webGLTexture != null && gl.ctx.isTexture(webGLTexture)){
      return new WebGLTexture.fromWebGL(webGLTexture);
    }
    return null;
  }
  // > TEXTURE_BINDING_CUBE_MAP
  WebGLTexture get boundTextureCubeMap {
    WebGL.Texture webGLTexture = gl.ctx.getParameter(ContextParameter.TEXTURE_BINDING_CUBE_MAP.index);
    if(webGLTexture != null && gl.ctx.isTexture(webGLTexture)){
      return new WebGLTexture.fromWebGL(webGLTexture);
    }
    return null;
  }

  void bind(TextureTarget target, WebGLTexture texture) {
    gl.ctx.bindTexture(target.index, texture.webGLTexture);
  }

  void bindToUnit(TextureUnit textureUnit, TextureTarget target, WebGLTexture texture) {
    TextureUnit lastTextureUnit = _instance.activeUnit;

    _instance.activeUnit = textureUnit;
    bind(target, texture);

    _instance.activeUnit = lastTextureUnit;
  }

  void unBind(TextureTarget target) {
    gl.ctx.bindTexture(target.index, null);
  }

  void unBindUnit(TextureUnit textureUnit, TextureTarget target) {
    TextureUnit lastTextureUnit = _instance.activeUnit;

    _instance.activeUnit = textureUnit;
    unBind(target);

    _instance.activeUnit = lastTextureUnit;
  }

  // Set values
  void setParameterFloat(
      TextureTarget target, TextureParameter parameter, num value) {
    gl.ctx.texParameterf(target.index, parameter.index, value);
  }

  void setParameterInt(
      TextureTarget target, TextureParameter parameter, TextureSetParameterType value) {
    gl.ctx.texParameteri(target.index, parameter.index, value.index);
  }

  // >>> Parameters

  dynamic getParameter(TextureTarget target, TextureParameter parameter) {
    dynamic result =
    gl.ctx.getTexParameter(target.index, parameter.index);
    return result;
  }
  // >>> single getParameter
  // > TEXTURE_MAG_FILTER
  TextureMagnificationFilterType get texture2DTextureMagFilter => TextureMagnificationFilterType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameter.TEXTURE_MAG_FILTER.index));
  TextureMagnificationFilterType get textureCubeMapTextureMagFilter => TextureMagnificationFilterType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameter.TEXTURE_MAG_FILTER.index));
  // > TEXTURE_MIN_FILTER
  TextureMinificationFilterType get texture2DTextureMinFilter => TextureMinificationFilterType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameter.TEXTURE_MIN_FILTER.index));
  TextureMinificationFilterType get textureCubeMapTextureMinFilter => TextureMinificationFilterType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameter.TEXTURE_MIN_FILTER.index));
  // > TEXTURE_WRAP_S
  TextureWrapType get texture2DTextureWrapS => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameter.TEXTURE_WRAP_S.index));
  TextureWrapType get textureCubeMapTextureWrapS => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameter.TEXTURE_WRAP_S.index));
  // > TEXTURE_WRAP_T
  TextureWrapType get texture2DTextureWrapT => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameter.TEXTURE_WRAP_T.index));
  TextureWrapType get textureCubeMapTextureWrapT => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameter.TEXTURE_WRAP_T.index));


  // > Logging

  void logTextureUnitInfo({TextureUnit textureUnit}){
    Utils.log('ActiveTexture', (){
      TextureUnit lastTextureUnit = _instance.activeUnit;

      _instance.activeUnit = textureUnit;
      print('activeTexture : ${_instance.activeUnit}');
      WebGLTexture boundTexture = boundTexture2D;
      boundTexture?.logTextureInfos();

      _instance.activeUnit = lastTextureUnit;
    });
  }

  void logActiveTextureInfo(){
    Utils.log('ActiveTexture', (){
      print('maxTextureImageUnits : ${maxTextureImageUnits}');
      print('maxCombinedTextureImageUnits : ${maxCombinedTextureImageUnits}');
      print('maxCubeMapTextureSize : ${maxCubeMapTextureSize}');
      print('maxTextureSize : ${maxTextureSize}');
      print('generateMipMapHint : ${generateMipMapHint}');

      print('### texture bindings #############################################');
      print('activeUnit : ${_instance.activeUnit}');
      WebGLTexture texture2D = boundTexture2D;
      if(texture2D != null) {
        print('... texture2D binding ............................................');
        print('boundTexture2D : ${texture2D}');
        print('texture2DTextureMagFilter : ${texture2DTextureMagFilter}');
        print('texture2DTextureMinFilter : ${texture2DTextureMinFilter}');
        print('texture2DTextureWrapS : ${texture2DTextureWrapS}');
        print('texture2DTextureWrapT : ${texture2DTextureWrapT}');
      }else{
        print('### no texture2D bound');
      }
      WebGLTexture textureCubeMap = boundTextureCubeMap;
      if(textureCubeMap != null) {
        print('... textureCubeMap binding .......................................');
        print('boundTextureCubeMap : ${textureCubeMap}');
        print('textureCubeMapTextureMagFilter : ${textureCubeMapTextureMagFilter}');
        print('textureCubeMapTextureMinFilter : ${textureCubeMapTextureMinFilter}');
        print('textureCubeMapTextureWrapS : ${textureCubeMapTextureWrapS}');
        print('textureCubeMapTextureWrapS : ${textureCubeMapTextureWrapS}');
        print('textureCubeMapTextureWrapT : ${textureCubeMapTextureWrapT}');
      }else{
        print('### no textureCubeMap bound');
      }
    });
  }
}