import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:test_webgl/src/camera/camera.dart';
import 'package:test_webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:test_webgl/src/webgl_objects/webgl_constants.dart';
import 'package:test_webgl/src/webgl_objects/webgl_parameters.dart';
import 'package:test_webgl/src/controllers/camera_controllers.dart';
import 'package:test_webgl/src/render_setting.dart';
import 'dart:web_gl' as WebGL;
import 'package:test_webgl/src/webgl_objects/webgl_rendering_context.dart';
@MirrorsUsed(
    targets: const [
      Context,
    ],
    override: '*')
import 'dart:mirrors';

WebGL.RenderingContext get gl => Context._glWrapper.gl;
set gl(WebGL.RenderingContext ctx) => Context._glWrapper = new WebGLRenderingContext.fromWebGL(ctx);

class Context{

  static WebGLRenderingContext _glWrapper;
  static WebGLRenderingContext get glWrapper => _glWrapper;
  static set glWrapper(WebGLRenderingContext value) => _glWrapper = value;

  static Vector4 _backgroundColor;
  static Vector4 get backgroundColor => _backgroundColor;
  static set backgroundColor(Vector4 color) {
    _backgroundColor = color;
    gl.clearColor(color.r, color.g, color.g, color.a);
  }

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
    Context.glWrapper = new WebGLRenderingContext.create(canvas);

    if(initConstant) {
      _initWebglConstants();
    }

    if(enableExtensions){
      renderSettings.enableExtensions(log: logInfos);
    }

    if(logInfos) {
      _logInfos();
    }

    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    gl.frontFace(FrontFaceDirection.CCW);

    Context.renderSettings.enableDepth(true);
    Context.renderSettings.showBackFace(true);
    Context.renderSettings.enableExtensions();
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

  static void resizeCanvas() {
    var realToCSSPixels = 1.0;//window.devicePixelRatio;

    // Lookup the size the browser is displaying the canvas.
//    var displayWidth = (_canvas.parent.offsetWidth* realToCSSPixels).floor();
//    var displayHeight = (window.innerHeight* realToCSSPixels).floor();

    var displayWidth  = (gl.canvas.clientWidth  * realToCSSPixels).floor();
    var displayHeight = (gl.canvas.clientHeight * realToCSSPixels).floor();

    // Check if the canvas is not the same size.
    if (gl.canvas.width != displayWidth || gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width = displayWidth;
      gl.canvas.height = displayHeight;

//      gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
      gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
      Context.mainCamera?.update();
    }
  }
}



