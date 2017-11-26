import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_constants.dart';
import 'package:webgl/src/webgl_objects/webgl_parameters.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/render_setting.dart';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
@MirrorsUsed(
    targets: const [
      Context,
    ],
    override: '*')
import 'dart:mirrors';

WebGLRenderingContext glWrapper;
WebGL.RenderingContext get gl => glWrapper.gl;
set gl(WebGL.RenderingContext ctx) => glWrapper = new WebGLRenderingContext.fromWebGL(ctx);

class Context{

  static Application get application => Application.instance;
  static Scene get currentScene => Application.instance != null ? Application.instance.currentScene as Scene : null;

  Vector4 _backgroundColor;
  Vector4 get backgroundColor => _backgroundColor;
  set backgroundColor(Vector4 color) {
    _backgroundColor = color;
    gl.clearColor(color.r, color.g, color.g, color.a);
  }

  static GLTFCameraPerspective _mainCamera;
  static GLTFCameraPerspective get mainCamera => _mainCamera;
  static set mainCamera(GLTFCameraPerspective value) {
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
    glWrapper = new WebGLRenderingContext.create(canvas);

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
    glWrapper.contextAttributes.logValues();
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



