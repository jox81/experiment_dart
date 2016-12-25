import 'dart:async';
import 'dart:web_gl';
import 'dart:html';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/shaders.dart';
import 'package:webgl/src/ui_models/toolbar.dart';
import 'package:webgl/src/webgl_debug_js.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:vector_math/vector_math.dart';

enum AxisType { view, x, y, z , any}
enum ToolType { select, move, rotate, scale }

class Application {
  static const bool debugging = false;

  static IUpdatableScene _currentScene;
  static IUpdatableScene get currentScene => _currentScene;

  CanvasElement _canvas;

  AxisType _currentAxis = AxisType.x;
  AxisType get currentAxis => _currentAxis;
  set currentAxis(AxisType value){
    _currentAxis = value;
    print('currentAxis : $_currentAxis');
  }

  ToolType _currentTool = ToolType.select;
  ToolType get currentTool => _currentTool;
  set currentTool(ToolType value){
    _currentTool = value;
    print('currentTool : $_currentTool');
  }

  Map<String, ToolBar> toolBars;

  //Singleton
  static Application _instance;
  static Future<Application> create(CanvasElement canvas) async {
    if (_instance == null) {
      _instance = new Application._internal(canvas);
      await ShaderSource.loadShaders();
    }

    return _instance;
  }

  Application._internal(this._canvas) {
    _initGL(_canvas);
    _initEvents();
    _resizeCanvas();
    _initToolBars();

  }

  void _initToolBars() {
    toolBars = {};

    ToolBar toolBarAxis = new ToolBar()
      ..toolBarItems = {
        "x": (bool isActive) => currentAxis = isActive ? AxisType.x : AxisType.view,
        "y": (bool isActive) => currentAxis = isActive ? AxisType.y : AxisType.view,
        "z": (bool isActive) => currentAxis = isActive ? AxisType.z : AxisType.view,
      };
    toolBars['axis'] = toolBarAxis;

    ToolBar toolBarTransformTools = new ToolBar()
      ..toolBarItems = {
        "s": (bool isActive) => currentTool = isActive ? ToolType.select : ToolType.select,//Todo : change function
        "M": (bool isActive) => currentTool = isActive ? ToolType.move : ToolType.select,
        "R": (bool isActive) => currentTool = isActive ? ToolType.rotate : ToolType.select,
        "S": (bool isActive) => currentTool = isActive ? ToolType.scale : ToolType.select,
      };
    toolBars['transformTool'] = toolBarTransformTools;
  }

  void _initGL(CanvasElement canvas) {
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
          gl = WebGLDebugUtils.makeDebugContext(gl, throwOnGLError,
              logAndValidate); //Kronos debug context using .js
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

    gl.clear(RenderingContext.COLOR_BUFFER_BIT);
    gl.frontFace(RenderingContext.CCW);

    Context.renderSettings.enableDepth(true);
    Context.renderSettings.showBackFace(true);
    Context.renderSettings.enableExtensions();
  }

  void _initEvents() {
    window.onResize.listen((e) => _resizeCanvas());
  }

  void _resizeCanvas() {
    // Lookup the size the browser is displaying the canvas.
    var displayWidth = _canvas.parent.offsetWidth;
    var displayHeight = window.innerHeight;

    // Check if the canvas is not the same size.
    if (gl.canvas.width != displayWidth || gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width = displayWidth;
      gl.canvas.height = displayHeight;

      gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    }
  }

  void render(IUpdatableScene scene) {
    _currentScene = scene;
    _resizeCanvas();
    _render();
  }

  void _render({num time: 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    clear(_currentScene.backgroundColor);

    _currentScene.updateUserInput();
    _currentScene.update(time);
    _currentScene.render();

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

  void clear(Vector4 color) {
    gl.clearColor(color.r, color.g, color.b, color.a);
    gl.clear(
        RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);
  }
}
