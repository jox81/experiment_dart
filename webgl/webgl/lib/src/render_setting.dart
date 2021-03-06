import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

class RenderSetting{

  final WebGLRenderingContext gl;
  RenderSetting(this.gl);

  void showBackFace(bool visible){
    if(!visible) {
      gl.enable(EnableCapabilityType.CULL_FACE);
      gl.cullFace(FacingType.BACK);
    }
  }

  void enableDepth(bool enable) {
    if(enable) {
      gl.clear(ClearBufferMask.DEPTH_BUFFER_BIT);
      gl.enable(EnableCapabilityType.DEPTH_TEST);
    }
  }

  void logSupportedExtensions(){
    Debug.log('Supported extensions',(){
      for(String extension in gl.getSupportedExtensions()){
        print(extension);
      }
    });
  }

  void enableExtensions({bool log : false}) {
    List<String> extensionNames = [
      'OES_texture_float',
      'OES_depth_texture',
      'WEBGL_depth_texture',
      'WEBKIT_WEBGL_depth_texture',
    ];

    Map extensions = new Map<String, Object>();
    for(String extensionName in extensionNames){
      dynamic extension = gl.getExtension(extensionName);
      extensions[extensionName] = extension;
    }

    if(log) {
      Debug.log('Enabling extensions', () {
        extensions.forEach((dynamic key, dynamic value) {
          print('$key : ${(value != null) ? 'enabled' : 'not available'}');
        });
      });
    }
  }
}