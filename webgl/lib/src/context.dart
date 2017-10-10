import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/webgl_objects/webgl_constants.dart';
import 'package:webgl/src/webgl_objects/webgl_parameters.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/render_setting.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
@MirrorsUsed(
    targets: const [
      Context,
    ],
    override: '*')
import 'dart:mirrors';

WebGLRenderingContext gl;

class Context{

  static CameraPerspective _mainCamera;
  static CameraPerspective get mainCamera => _mainCamera;
  static set mainCamera(CameraPerspective value) {
    _mainCamera?.isActive = false;

    _mainCamera = value;
    _mainCamera.isActive = true;
    _mainCamera.cameraController = cameraController;
  }

  static CameraController _cameraController;
  static CameraController get cameraController{
    if(_cameraController == null){
      _cameraController = new CameraController();
    }
    return _cameraController;
  }

  //Use to add parenting models space (hierarchy)
  static Matrix4 modelMatrix = new Matrix4.identity();

  static num get width => gl.drawingBufferWidth;
  static num get height => gl.drawingBufferHeight;

  static double get viewAspectRatio {
    if(gl != null) {
      return width / height;
    }
    return 1.0;
  }

  static RenderSetting _renderSetting;
  static RenderSetting get renderSettings {
    if(_renderSetting == null){
      _renderSetting = new RenderSetting();
    }
    return _renderSetting;
  }

  static const bool debugging = false;

  static void init(CanvasElement canvas, {bool enableExtensions:false, bool initConstant : false, bool logInfos : false}){
    gl = new WebGLRenderingContext.create(canvas);

    if(initConstant) {
      _initWebglConstants();
    }

    if(enableExtensions){
      renderSettings.enableExtensions(log: logInfos);
    }

    if(logInfos) {
      _logInfos();
    }
  }

  static void _logInfos() {
    gl.contextAttributes.logValues();
    _renderSetting.logSupportedExtensions();
    Context.webglConstants.logConstants();
    Context.webglConstants.logParameters();
    Context.webglParameters.logValues();

    Context.webglParameters.testGetParameter();
  }

  static void _initWebglConstants() {
    webglConstants.initWebglConstants();
  }

  static WebglConstants get webglConstants => WebglConstants.instance();
  static WebglParameters get webglParameters => WebglParameters.instance();
}



