import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/utils/utils_renderer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

WebGL.RenderingContext get gl => Context._gl?.gl;

class Context{
  static WebGLRenderingContext _gl;
  static WebGLRenderingContext get glWrapper => _gl;

  static CameraPerspective _mainCamera = new
    CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  static CameraPerspective get mainCamera => _mainCamera;
  static set mainCamera(CameraPerspective value) {
    _mainCamera?.isActive = false;

    _mainCamera = value;
    _mainCamera.isActive = true;
  }

  //Use to add parenting models space (hierarchy)
  static Matrix4 modelMatrix = new Matrix4.identity();

//  bool debugging = false;

  void init(CanvasElement canvas, {bool enableExtensions:false, bool initConstant : false, bool logInfos : false}){
    _gl = new WebGLRenderingContext.create(canvas);

    if(initConstant) {
      _gl.webglConstants.initWebglConstants();
    }

    if(enableExtensions){
      _gl.renderSettings.enableExtensions(log: logInfos);
    }

    if(logInfos) {
      _logInfos();
    }

    _gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    _gl.frontFace = FrontFaceDirection.CCW;

    _gl.renderSettings.enableDepth(true);
    _gl.renderSettings.showBackFace(true);
    _gl.renderSettings.enableExtensions();
  }

  void _logInfos() {
    _gl.contextAttributes.logValues();
    _gl.renderSettings.logSupportedExtensions();
    _gl.webglConstants.logConstants();
    _gl.webglConstants.logParameters();
    _gl.webglParameters.logValues();

    _gl.webglParameters.testGetParameter();
  }

  GlobalState _globalState;
  GlobalState get globalState => _globalState ??= _getGlobalState();
  GlobalState _getGlobalState() {
    //> Init extensions
    //This activate extensions
    bool hasSRGBExt = gl.getExtension('EXT_SRGB') != null;
    bool hasLODExtension = gl.getExtension('EXT_shader_texture_lod') != null;
    bool hasDerivativesExtension = gl.getExtension('OES_standard_derivatives') != null;
    bool hasIndexUIntExtension = gl.getExtension('OES_element_index_uint') != null;

    return new GlobalState()
      ..hasLODExtension = hasLODExtension
      ..hasDerivativesExtension = hasDerivativesExtension
      ..hasIndexUIntExtension = hasIndexUIntExtension
      ..sRGBifAvailable =
      hasSRGBExt ? WebGL.EXTsRgb.SRGB_EXT : WebGL.WebGL.RGBA;
  }
}