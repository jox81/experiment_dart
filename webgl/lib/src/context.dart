import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/debug_rendering_context.dart';

RenderingContext gl;

class Context{

  static Camera _mainCamera;
  static Camera get mainCamera => _mainCamera;
  static set mainCamera(Camera value) {
    _mainCamera?.isActive = false;
    _mainCamera = value;
    _mainCamera.isActive = true;
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

  static const bool debugging = false;

  static void init(CanvasElement canvas){
    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    var options = {
      'preserveDrawingBuffer': true,
    };

    for (int i = 0; i < names.length; ++i) {
      try {
        gl = canvas.getContext(names[i], options); //Normal context
        if (debugging) {
          gl = new DebugRenderingContext(gl);
        }
      } catch (e) {}
      if (gl != null) {
        break;
      }
    }
    if (gl == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }
  }
}

class RenderSetting{
  RenderSetting();

  void showBackFace(bool visible){
    if(!visible) {
      gl.enable(RenderingContext.CULL_FACE);
      gl.cullFace(RenderingContext.BACK);
    }
    
  }

  void enableDepth(bool enable) {
    if(enable) {
      gl.clear(RenderingContext.DEPTH_BUFFER_BIT);
      gl.enable(DEPTH_TEST);
    }
  }

  void enableExtensions() {
//    print('###');
//    print('Possible extensions : ');
//    for(String extension in gl.getSupportedExtensions()){
//      print(extension);
//    }

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

//    print('###');
//    print('Enabling extensions : ');
    List<String> extensionNames = [
      'OES_texture_float',
      'OES_depth_texture',
//      'WEBGL_depth_texture',
//      'WEBKIT_WEBGL_depth_texture',
    ];

    var extension;
    for(String extensionName in extensionNames){
      extension = gl.getExtension(extensionName);
      print('$extensionName : ${(extension != null)?'enabled':'not available'}');
    }
  }
}

