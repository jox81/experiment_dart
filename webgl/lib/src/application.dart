import 'dart:web_gl';
import 'dart:html';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/webgl_debug_js.dart';
import 'package:webgl/src/scene.dart';

typedef void UpdateFunction(num time);

RenderingContext get gl => Application._gl;
Scene get scene => Application._instance._currentScene;

class Application {
  static const bool debugging = false;

  static RenderingContext _gl;

  Scene _currentScene;

  num get viewAspectRatio => gl.drawingBufferWidth / gl.drawingBufferHeight;

  //Singleton
  static Application _instance;
  factory Application(CanvasElement canvas) {
    canvas.width = document.body.clientWidth;
    canvas.height = document.body.clientHeight;

    if (_instance == null) {
      _instance = new Application._internal(canvas);
    }

    return _instance;
  }

  Application._internal(CanvasElement canvas) {
    _initGL(canvas);
    _initEvents();
  }

  void _initGL(CanvasElement canvas) {
    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    for (int i = 0; i < names.length; ++i) {
      try {
        _gl = canvas.getContext(names[i]); //Normal context
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
    var displayWidth  = window.innerWidth;
    var displayHeight = window.innerHeight;

    // Check if the canvas is not the same size.
    if (gl.canvas.width  != displayWidth ||
        gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width  = displayWidth;
      gl.canvas.height = displayHeight;

      _currentScene?.mainCamera?.aspectRatio = viewAspectRatio;

      gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    }
  }

  void render(Scene scene){
    _currentScene = scene;
    _render();
  }
  void _render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clearColor(_currentScene.backgroundColor.r, _currentScene.backgroundColor.g, _currentScene.backgroundColor.b, _currentScene.backgroundColor.a);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    _currentScene.update(time);
    _currentScene.render();

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

}
