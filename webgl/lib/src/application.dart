import 'dart:web_gl';
import 'dart:html';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/webgl_debug_js.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:vector_math/vector_math.dart';

RenderingContext get gl => Application._gl;
Scene get scene => Application._instance._currentScene;

class Application {
  static const bool debugging = false;

  static RenderingContext _gl;

  CanvasElement _canvas;

  IUpdatableScene _currentScene;

  num get viewAspectRatio => gl.drawingBufferWidth / gl.drawingBufferHeight;

  //Singleton
  static Application _instance;
  factory Application(CanvasElement canvas) {

    if (_instance == null) {
      _instance = new Application._internal(canvas);
    }

    return _instance;
  }

  Application._internal(this._canvas) {
    _initGL(_canvas);
    _initEvents();
    _resizeCanvas();

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
        _gl = canvas.getContext(names[i], options); //Normal context
        if (debugging) {
          _gl = WebGLDebugUtils.makeDebugContext(gl, throwOnGLError,
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

    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
    gl.enable(DEPTH_TEST);

    /*
    //Hide backfaces
    gl.enable(GL.CULL_FACE);
    gl.frontFace(GL.CCW);
    gl.cullFace(GL.BACK);
    */
  }

  void _initEvents() {
    window.onResize.listen((e)=>_resizeCanvas());
  }

  void _resizeCanvas() {
    // Lookup the size the browser is displaying the canvas.
    var displayWidth  = _canvas.parent.offsetWidth;
    var displayHeight = window.innerHeight;

    // Check if the canvas is not the same size.
    if (gl.canvas.width  != displayWidth ||
        gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width  = displayWidth;
      gl.canvas.height = displayHeight;

      _currentScene?.mainCamera?.aspectRatio = gl.drawingBufferWidth / gl.drawingBufferHeight;

      gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    }
  }

  void render(IUpdatableScene scene){
    _currentScene = scene;
    _resizeCanvas();
    _render();
  }

  void _render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    clear(_currentScene.backgroundColor);

    _currentScene.updateUserInput();
    _currentScene.update(time);
    _currentScene.render();

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

  void clear(Vector4 color){
    gl.clearColor(color.r, color.g, color.b, color.a);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
  }

}
