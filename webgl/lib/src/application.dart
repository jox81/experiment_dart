import 'dart:async';
import 'dart:html';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/context.dart' as Context;
import 'dart:web_gl' as WebGL;

@MirrorsUsed(
    targets: const [
      AxisType,
      ActiveToolType,
      Application,
    ],
    override: '*')
import 'dart:mirrors';

enum AxisType { view, x, y, z, any }
enum ActiveToolType { select, move, rotate, scale }

class Application {

  //Singleton
  static Application _instance;
  static Application get instance => _instance;
  static Future<Application> create(CanvasElement canvas) async {
    if (_instance == null) {
      _instance = new Application._internal(canvas);
      await ShaderSource.loadShaders();
    }

    return _instance;
  }

  Application._internal(this._canvas) {
    _initGL(_canvas);
    resizeCanvas();
  }

  IUpdatableScene _currentScene;
  IUpdatableScene get currentScene => _currentScene;
  set currentScene(IUpdatableScene value) {
    _currentScene = null;
    _currentScene = value;
  }

  WebGL.RenderingContext get gl => Context.gl;

  CanvasElement _canvas;

  /// Active Axis
  Map<AxisType, bool> _activeAxis = {
    AxisType.x: false,
    AxisType.y: false,
    AxisType.z: false,
  };
  Map<AxisType, bool> get activeAxis => _activeAxis;
  set activeAxis(Map<AxisType, bool> value) {
    _activeAxis = value;
  }

  void setActiveAxis(AxisType axisType, bool isActive) {
    _activeAxis[axisType] = isActive;
    print(_activeAxis);
  }

  ///Active Tool
  ActiveToolType _activeTool = ActiveToolType.select;
  ActiveToolType get activeTool => _activeTool;

  void setActiveTool(ActiveToolType value) {
    _activeTool = value;
    print(_activeTool);
    switch (_activeTool){
      case ActiveToolType.select:
        Context.Context.mainCamera.isActive = true;
        break;
      case ActiveToolType.move:
        Context.Context.mainCamera.isActive = false;
        break;
      case ActiveToolType.rotate:
        Context.Context.mainCamera.isActive = false;
        break;
      case ActiveToolType.scale:
        Context.Context.mainCamera.isActive = false;
        break;
    }
  }

  void _initGL(CanvasElement canvas) {

    Context.Context.init(canvas);

    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    gl.frontFace(FrontFaceDirection.CCW);

    Context.Context.renderSettings.enableDepth(true);
    Context.Context.renderSettings.showBackFace(true);
    Context.Context.renderSettings.enableExtensions();
  }

  void resizeCanvas() {
    // Lookup the size the browser is displaying the canvas.
    var displayWidth = _canvas.parent.offsetWidth;
    var displayHeight = window.innerHeight;

    // Check if the canvas is not the same size.
    if (gl.canvas.width != displayWidth || gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width = displayWidth;
      gl.canvas.height = displayHeight;

      gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
      Context.Context.mainCamera?.update();
    }
  }

  void render() {
    if(_currentScene == null) throw new Exception("Application currentScene must be set before rendering.");
    resizeCanvas();
    _render();
  }

  void _render({num time: 0.0}) {
    Time.currentTime = time;

    _renderCurrentScene();

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

  void _renderCurrentScene() {
//    window.console.time('01_application::_renderCurrentScene');

    gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
    clear(_currentScene.backgroundColor);

    _currentScene.update();
    _currentScene.render();

//    window.console.timeEnd('01_application::_renderCurrentScene');
  }

  void clear(Vector4 color) {
    gl.clearColor(color.r, color.g, color.g, color.a);
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);
  }
}
