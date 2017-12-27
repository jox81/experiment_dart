import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/geometry/utils_geometry.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/context.dart' hide gl;
import 'package:webgl/src/context.dart' as ctxWrapper show gl;
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/scene.dart';
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

//  static Scene get currentScene => Application.instance != null ? Application.instance.currentScene as Scene : null;


  //Singleton
  static Application _instance;
  static Application get instance => _instance;

  Interaction _interaction;
  Interaction get interaction => _interaction;
  CameraPerspective get mainCamera => Context.mainCamera;

  CanvasElement _canvas;
  CanvasElement get canvas => _canvas;

  WebGL.RenderingContext get gl => ctxWrapper.gl;

  Application._internal(this._canvas){
    Context.init(canvas);
    initInteraction();
    Context.resizeCanvas();
  }

  static Future<Application> create(CanvasElement canvas) async {
    if (_instance == null) {
      _instance = new Application._internal(canvas);
      await ShaderSource.loadShaders();
    }

    return _instance;
  }

  IUpdatableScene _currentScene;
  Scene get currentScene => _currentScene as Scene;
  set currentScene(Scene value) {
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
        Context.mainCamera.isActive = true;
        break;
      case ActiveToolType.move:
        Context.mainCamera.isActive = false;
        break;
      case ActiveToolType.rotate:
        Context.mainCamera.isActive = false;
        break;
      case ActiveToolType.scale:
        Context.mainCamera.isActive = false;
        break;
    }
  }

  Mesh tempSelection;

  void initInteraction(){
    _interaction = new Interaction(this);

    _interaction.onMouseDown.listen(_onMouseDownHandler);
    _interaction.onMouseUp.listen(_onMouseUpHandler);
    _interaction.onDrag.listen(_onDragHandler);
    _interaction.onResize.listen((dynamic event){Context.resizeCanvas();});
  }

  void _onMouseDownHandler(MouseEvent event) {
    if (Context.mainCamera != null) {
      Mesh modelHit = UtilsGeometry.findModelFromMouseCoords(
          Context.mainCamera, event.offset.x, event.offset.y,
          currentScene.models);
      tempSelection = modelHit;
    }
  }

  void _onMouseUpHandler(MouseEvent event) {
    if(!_interaction.dragging) {
      currentScene.currentSelection = tempSelection;
    }
  }

  void _onDragHandler(dynamic event){
    if(activeTool == ActiveToolType.move ||
        activeTool == ActiveToolType.rotate ||
        activeTool == ActiveToolType.scale) {
      currentScene.currentSelection = tempSelection;
    }

    if(currentScene.currentSelection != null && currentScene.currentSelection is Mesh) {

      Mesh currentModel = currentScene.currentSelection as Mesh;

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

        currentModel.matrix.translate(
            new Vector3(deltaMoveX * moveFactor, deltaMoveY * moveFactor, deltaMoveZ * moveFactor));
      }

      if (activeTool == ActiveToolType.rotate) {
        num rotateFactor = 1.0;

        currentModel.matrix.rotateX(deltaMoveX * rotateFactor);
        currentModel.matrix.rotateY(deltaMoveY * rotateFactor);
        currentModel.matrix.rotateY(deltaMoveZ * rotateFactor);
      }

      if (activeTool == ActiveToolType.scale) {
        num scaleFactor = 0.03;

        currentModel.matrix.scale( 1.0 + deltaMoveX * scaleFactor, 1.0 + deltaMoveY * scaleFactor, 1.0 + deltaMoveZ * scaleFactor,);
      }
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
    Context.resizeCanvas();

    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    _currentScene.update();
    _currentScene.render();
  }
}
