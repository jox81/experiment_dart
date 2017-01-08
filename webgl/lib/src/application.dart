import 'dart:async';
import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/ui_models/toolbar.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

enum AxisType { view, x, y, z, any }
enum ToolType { select, move, rotate, scale }

class Application {

  static IUpdatableScene _currentScene;
  static IUpdatableScene get currentScene => _currentScene;

  CanvasElement _canvas;

  ///
  Map<AxisType, bool> _activeAxis = {
    AxisType.x: false,
    AxisType.y: false,
    AxisType.z: false,
  };
  Map<AxisType, bool> get activeAxis => _activeAxis;
  set activeAxis(Map<AxisType, bool> value) {
    _activeAxis = value;
  }

  setActiveAxis(AxisType axisType, bool isActive) {
    _activeAxis[axisType] = isActive;
    print(_activeAxis);
  }

  ///
  ToolType _activeTool = ToolType.select;
  ToolType get activeTool => _activeTool;

  setActiveTool(ToolType value) {
    _activeTool = value;
    print(_activeTool);
    switch (_activeTool){
      case ToolType.select:
        Context.mainCamera.isActive = true;
        break;
      case ToolType.move:
        Context.mainCamera.isActive = false;
        break;
      case ToolType.rotate:
        Context.mainCamera.isActive = false;
        break;
      case ToolType.scale:
        Context.mainCamera.isActive = false;
        break;
    }
  }

  Map<String, ToolBar> toolBars;

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
    _initToolBars();
  }

  void _initToolBars() {
    toolBars = {};

    ToolBar toolBarAxis = new ToolBar(ToolBarItemsType.multi)
      ..toolBarItems = {
        "x": (bool isActive) => setActiveAxis(AxisType.x, isActive),
        "y": (bool isActive) => setActiveAxis(AxisType.y, isActive),
        "z": (bool isActive) => setActiveAxis(AxisType.z, isActive),
      };
    toolBars['axis'] = toolBarAxis;

    ToolBar toolBarTransformTools = new ToolBar(ToolBarItemsType.single)
      ..toolBarItems = {
        "s": (bool isActive) => setActiveTool(ToolType.select),
        "M": (bool isActive) => setActiveTool(ToolType.move),
        "R": (bool isActive) => setActiveTool(ToolType.rotate),
        "S": (bool isActive) => setActiveTool(ToolType.scale),
      };
    toolBars['transformTool'] = toolBarTransformTools;
  }

  void _initGL(CanvasElement canvas) {

    Context.init(canvas);

    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT]);
    gl.frontFace = FrontFaceDirection.CCW;

    Context.renderSettings.enableDepth(true);
    Context.renderSettings.showBackFace(true);
    Context.renderSettings.enableExtensions();
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

      gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    }
  }

  void render(IUpdatableScene scene) {
    _currentScene = scene;
    resizeCanvas();
    _render();
  }

  void _render({num time: 0.0}) {
    gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    clear(_currentScene.backgroundColor);

    _currentScene.updateUserInput();
    _currentScene.update(time);
    _currentScene.render();

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

  void clear(Vector4 color) {
    gl.clearColor = color;
    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);
  }
}
