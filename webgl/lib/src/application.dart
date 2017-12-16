import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/geometry/utils_geometry.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/context.dart' as ctxWrapper;
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/camera.dart';
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

class Application implements Interactable{

  //Singleton
  static Application _instance;
  static Application get instance => _instance;

  Interaction _interaction;
  Interaction get interaction => _interaction;
  CameraPerspective get mainCamera => ctxWrapper.Context.mainCamera;

  CanvasElement _canvas;
  CanvasElement get canvas => _canvas;

  WebGL.RenderingContext get gl => ctxWrapper.gl;

  Application._internal(this._canvas){
    _initGL(_canvas);
    initInteraction();
    resizeCanvas();
  }

  static Future<Application> create(CanvasElement canvas) async {
    if (_instance == null) {
      _instance = new Application._internal(canvas);
      await ShaderSource.loadShaders();
    }

    return _instance;
  }

  IUpdatableScene _currentScene;
  IUpdatableScene get currentScene => _currentScene;
  set currentScene(IUpdatableScene value) {
    _currentScene = null;
    _currentScene = value;
  }


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
        ctxWrapper.Context.mainCamera.isActive = true;
        break;
      case ActiveToolType.move:
        ctxWrapper.Context.mainCamera.isActive = false;
        break;
      case ActiveToolType.rotate:
        ctxWrapper.Context.mainCamera.isActive = false;
        break;
      case ActiveToolType.scale:
        ctxWrapper.Context.mainCamera.isActive = false;
        break;
    }
  }

  void _initGL(CanvasElement canvas) {

    ctxWrapper.Context.init(canvas);

    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    gl.frontFace(FrontFaceDirection.CCW);

    ctxWrapper.Context.renderSettings.enableDepth(true);
    ctxWrapper.Context.renderSettings.showBackFace(true);
    ctxWrapper.Context.renderSettings.enableExtensions();
  }

  Model tempSelection;

  void initInteraction(){
    _interaction = new Interaction(this);
    _interaction.onMouseDown.listen(_onMouseDownHandler);
    _interaction.onMouseUp.listen(_onMouseUpHandler);
    _interaction.onDrag.listen(_onDragHandler);
    _interaction.onResize.listen((dynamic event){resizeCanvas();});
  }

  void _onMouseDownHandler(MouseEvent event) {
    if (ctxWrapper.Context.mainCamera != null) {
      Model modelHit = UtilsGeometry.findModelFromMouseCoords(
          ctxWrapper.Context.mainCamera, event.offset.x, event.offset.y,
          ctxWrapper.Context.currentScene.models);
      tempSelection = modelHit;
    }
  }

  void _onMouseUpHandler(MouseEvent event) {
    if(!_interaction.dragging) {
      ctxWrapper.Context.currentScene.currentSelection = tempSelection;
    }
  }

  void _onDragHandler(dynamic event){
    if(activeTool == ActiveToolType.move ||
        activeTool == ActiveToolType.rotate ||
        activeTool == ActiveToolType.scale) {
      ctxWrapper.Context.currentScene.currentSelection = tempSelection;
    }

    if(ctxWrapper.Context.currentScene.currentSelection != null && ctxWrapper.Context.currentScene.currentSelection is Model) {

      Model currentModel = ctxWrapper.Context.currentScene.currentSelection as Model;

      double delta = _interaction.deltaX.toDouble(); // get mouse delta
      double deltaMoveX = (activeAxis[AxisType.x]
          ? 1
          : 0) * delta;
      double deltaMoveY = (activeAxis[AxisType.y]
          ? 1
          : 0) * delta;
      double deltaMoveZ = (activeAxis[AxisType.z]
          ? 1
          : 0) * delta;

      if (activeTool == ActiveToolType.move) {
        double moveFactor = 1.0;

        currentModel.transform.translate(
            new Vector3(deltaMoveX * moveFactor, deltaMoveY * moveFactor, deltaMoveZ * moveFactor));
      }

      if (activeTool == ActiveToolType.rotate) {
        num rotateFactor = 1.0;

        currentModel.transform.rotateX(deltaMoveX * rotateFactor);
        currentModel.transform.rotateY(deltaMoveY * rotateFactor);
        currentModel.transform.rotateY(deltaMoveZ * rotateFactor);
      }

      if (activeTool == ActiveToolType.scale) {
        num scaleFactor = 0.03;

        currentModel.transform.scale( 1.0 + deltaMoveX * scaleFactor, 1.0 + deltaMoveY * scaleFactor, 1.0 + deltaMoveZ * scaleFactor,);
      }
    }
  }

  void resizeCanvas() {
    var realToCSSPixels = window.devicePixelRatio;

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
      ctxWrapper.Context.mainCamera?.update();
    }
  }

  void render() {
    if(_currentScene == null) throw new Exception("Application currentScene must be set before rendering.");
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

    resizeCanvas();

    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    _currentScene.update();
    _currentScene.render();

//    window.console.timeEnd('01_application::_renderCurrentScene');
  }
}
