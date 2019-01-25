import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/textures/type/cube_map_texture.dart';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/webgl_objects/textures/type/2d_texture.dart';

class ActiveTexture {

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





