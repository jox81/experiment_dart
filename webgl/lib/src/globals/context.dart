import 'dart:web_gl';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';

RenderingContext gl;

class Context{

  static Camera _mainCamera;
  static Camera get mainCamera => _mainCamera;
  static set mainCamera(Camera value) {
    _mainCamera?.active = false;
    _mainCamera = value;
    _mainCamera.active = true;
  }

  static Matrix4 mvMatrix = new Matrix4.identity();

  static num get width => gl.drawingBufferWidth;
  static num get height => gl.drawingBufferHeight;

  static num get viewAspectRatio {
    if(gl != null) {
      return width / height;
    }
    return 1;
  }

  static RenderSetting _renderSetting;
  static RenderSetting get renderSettings {
    if(_renderSetting == null){
      _renderSetting = new RenderSetting();
    }
    return _renderSetting;
  }

}

class RenderSetting{
  RenderSetting();

  void showBackFace(bool visible){
    if(!visible) {
      gl.enable(GL.CULL_FACE);
      gl.cullFace(GL.BACK);
    }
  }

  void enableDepth(bool enable) {
    if(enable) {
      gl.clear(GL.DEPTH_BUFFER_BIT);
      gl.enable(DEPTH_TEST);
    }
  }

  void enableExtensions() {
    print('###');
    print('Possible extensions : ');
    for(String extension in gl.getSupportedExtensions()){
      print(extension);
    }

    /*
      :: in chromium ::
      ANGLE_instanced_arrays
      EXT_blend_minmax
      EXT_frag_depth
      EXT_shader_texture_lod
      EXT_sRGB
      EXT_texture_filter_anisotropic
      WEBKIT_EXT_texture_filter_anisotropic
      OES_element_index_uint
      OES_standard_derivatives
      OES_texture_float
      OES_texture_float_linear
      OES_texture_half_float
      OES_texture_half_float_linear
      OES_vertex_array_object
      WEBGL_compressed_texture_s3tc
      WEBKIT_WEBGL_compressed_texture_s3tc
      WEBGL_debug_renderer_info
      WEBGL_debug_shaders
      WEBGL_depth_texture
      WEBKIT_WEBGL_depth_texture
      WEBGL_draw_buffers
      WEBGL_lose_context
      WEBKIT_WEBGL_lose_context
    */

    print('###');
    print('Enabling extensions : ');
    List<String> extensionNames = [
      'OES_texture_float',
      'OES_depth_texture',
      'WEBGL_depth_texture',
      'WEBKIT_WEBGL_depth_texture',
    ];

    var extension;
    for(String extensionName in extensionNames){
      extension = gl.getExtension(extensionName);
      print('$extensionName : ${(extension != null)?'enabled':'not available'}');
    }
  }
}

