import 'package:webgl/src/mesh.dart';
import 'dart:web_gl';
import 'dart:html';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/material.dart';
import 'dart:collection';
import 'package:vector_math/vector_math.dart';
import 'dart:async';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/utils.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/application/src/dart_js/debug/webgl_debug_js.dart';

class Application {
  static const bool debugging = false;

  static RenderingContext gl;

  Camera mainCamera; //mainCamera.matrix.storage ==> projetion Matrix
  Matrix4 mvMatrix = new Matrix4.identity();

  Vector4 _backgroundColor;
  Vector4 get backgroundColor => _backgroundColor;
  set backgroundColor(Vector4 color) {
    _backgroundColor = color;
    gl.clearColor(color.r, color.g, color.b, color.a);
  }

  AmbientLight ambientLight = new AmbientLight();
  Light light;

  List<Material> materials = new List();
  List<Mesh> meshes = new List();

  num get viewAspectRatio => gl.drawingBufferWidth / gl.drawingBufferHeight;

  //Animation
  Queue<Matrix4> _mvMatrixStack = new Queue();

  //Interaction with keyboard
  List<bool> _currentlyPressedKeys;

  //Debug div
  Element elementDebugInfoText;
  Element elementFPSText;

  //Singleton
  static Application _instance;
  static Application get instance => _instance;
  factory Application(CanvasElement canvas) {
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
        gl = canvas.getContext(names[i]); //Normal context
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

    window.onResize.listen((e)=>resizeCanvas());

    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
    gl.enable(DEPTH_TEST);

    /*
    //Hide backfaces
    gl.enable(GL.CULL_FACE);
    gl.frontFace(GL.CCW);
    gl.cullFace(GL.BACK);
    */
  }

  void resizeCanvas() {
    // Lookup the size the browser is displaying the canvas.
    var displayWidth  = window.innerWidth;
    var displayHeight = window.innerHeight;

    // Check if the canvas is not the same size.
    if (gl.canvas.width  != displayWidth ||
        gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width  = displayWidth;
      gl.canvas.height = displayHeight;

      if(mainCamera != null) {
        mainCamera.aspectRatio = viewAspectRatio;
      }
      gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    }
  }

  void _initEvents() {
    //Without specifying size this array throws exception on []
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    window.onKeyUp.listen(this._handleKeyUp);
    window.onKeyDown.listen(this._handleKeyDown);

    elementDebugInfoText = querySelector("#debugInfosText");
    elementFPSText = querySelector("#fps");
  }

  Function _setupScene;
  void setupScene(Function sceneSetupFunction) {
    _setupScene = sceneSetupFunction;
  }

  Future render() async {
    await _setupScene();
    _renderFrame();
  }

  Function _updateScene;
  void updateScene(Function updateSceneFunction) {
    _updateScene = updateSceneFunction;
  }

  Future renderAnimation() async {
    await _setupScene();
    this._renderFrame();
  }

  double renderTime;
  void _renderFrame({num time : 0.0}) {
    //Fps
    var t = new DateTime.now().millisecondsSinceEpoch;
    if (renderTime != null) {
      Utils.showFps(elementFPSText, (1000 / (t - renderTime)).round());
    }
    renderTime = t.toDouble();

    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    for (Mesh model in meshes) {
      _mvPushMatrix();

      mvMatrix.multiply(model.transform);

      model.render();

      _mvPopMatrix();
    }

    if (time != null) {
      // render animation
      _updateScene(time);
      _handleKeys();
      window.requestAnimationFrame((num time) {
        this._renderFrame(time: time);
      });
    }
  }

  void _mvPushMatrix() {
    _mvMatrixStack.addFirst(mvMatrix.clone());
  }

  void _mvPopMatrix() {
    if (0 == _mvMatrixStack.length) {
      throw new Exception("Invalid popMatrix!");
    }
    mvMatrix = _mvMatrixStack.removeFirst();
  }

  ///
  ///Keyboard
  ///
  void _handleKeyDown(KeyboardEvent event) {
    if (KeyCode.UP == event.keyCode || KeyCode.DOWN == event.keyCode) {
      if ((elementDebugInfoText != null)) {
        elementDebugInfoText.text = "Camera Position: ${mainCamera.position}";
        print(event.keyCode);
      }
    } else {}
    _currentlyPressedKeys[event.keyCode] = true;
  }

  void _handleKeyUp(KeyboardEvent event) {
    if ((event.keyCode > 0) && (event.keyCode < 128))
      _currentlyPressedKeys[event.keyCode] = false;
  }

  void _handleKeys() {
    if (_currentlyPressedKeys[KeyCode.UP]) {
      // Key Up
      mainCamera.translate(new Vector3(0.0, 0.0, 0.1));
    }
    if (_currentlyPressedKeys[KeyCode.DOWN]) {
      // Key Down
      mainCamera.translate(new Vector3(0.0, 0.0, -0.1));
    }
    if (_currentlyPressedKeys[KeyCode.LEFT]) {
      // Key Up
      mainCamera.translate(new Vector3(-0.1, 0.0, 0.0));
    }
    if (_currentlyPressedKeys[KeyCode.RIGHT]) {
      // Key Down
      mainCamera.translate(new Vector3(0.1, 0.0, 0.0));
    }
  }
}
