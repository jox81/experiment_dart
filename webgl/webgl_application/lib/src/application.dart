import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/src/utils/utils_geometry.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/introspection.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

enum AxisType { view, x, y, z, any }
enum ActiveToolType { select, move, rotate, scale }

class Application implements ToolBarAxis, ToolBarTool{
  //Singleton
  static Application _instance;
  static Application get instance => _instance;
  static Future<Application> build(CanvasElement canvas) async {
    print("Application.build");
    if (instance == null) {
      _instance = new Application._(canvas);
    }
    return instance;
  }

  CanvasElement _canvas;
  CanvasElement get canvas => _canvas;

  GLTFScene get currentScene => project?.scene;

  CustomEditElement _currentSelection;
  CustomEditElement get currentSelection => _currentSelection;
  set currentSelection(CustomEditElement value) => _currentSelection = value;

  GLTFEngine engine;
  GLTFProject project;
  CameraPerspective get mainCamera => Engine.mainCamera;

  GLTFNode tempSelection;

  InteractionManager get interaction => engine.interaction;

  Application._(CanvasElement canvas){
    engine = new GLTFEngine(canvas);
    initInteraction();
  }

  void render() {
    engine.init();
    engine.render(project);
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

  @override
  void setActiveAxis(AxisType axisType, bool isActive) {
    _activeAxis[axisType] = isActive;
    print(_activeAxis);
  }

  ///Active Tool
  ActiveToolType _activeTool = ActiveToolType.select;
  ActiveToolType get activeTool => _activeTool;

  @override
  void setActiveTool(ActiveToolType value) {
    _activeTool = value;
    print(_activeTool);
    switch (_activeTool){
      case ActiveToolType.select:
        Engine.mainCamera.isActive = true;
        break;
      case ActiveToolType.move:
        Engine.mainCamera.isActive = false;
        break;
      case ActiveToolType.rotate:
        Engine.mainCamera.isActive = false;
        break;
      case ActiveToolType.scale:
        Engine.mainCamera.isActive = false;
        break;
    }
  }

  @override
  void initInteraction(){
    interaction.onMouseDown.listen(_onMouseDownHandler);
    interaction.onMouseUp.listen(_onMouseUpHandler);
    interaction.onDrag.listen(_onDragHandler);
    interaction.onResize.listen((dynamic event){GL.resizeCanvas();});
  }

  void _onMouseDownHandler(MouseEvent event) {
    if (Engine.mainCamera != null) {
      GLTFNode modelHit = UtilsGeometry.findNodeFromMouseCoords(
          Engine.mainCamera, event.offset.x, event.offset.y,
          currentScene.nodes);
      tempSelection = modelHit;
    }
  }

  void _onMouseUpHandler(MouseEvent event) {
    if(!interaction.dragging) {
      currentSelection = tempSelection != null ? new CustomEditElement(tempSelection) : null;
    }
  }

  void _onDragHandler(dynamic event){
    if(activeTool == ActiveToolType.move ||
        activeTool == ActiveToolType.rotate ||
        activeTool == ActiveToolType.scale) {
      currentSelection = tempSelection != null ? new CustomEditElement(tempSelection) : null;
    }

    if(currentSelection != null && currentSelection.element is GLTFNode) {

      GLTFNode currentItem = currentSelection.element as GLTFNode;

      double delta = interaction.deltaX.toDouble(); // get mouse delta
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

        currentItem.matrix.translate(
            new Vector3(deltaMoveX * moveFactor, deltaMoveY * moveFactor, deltaMoveZ * moveFactor));
      }

      if (activeTool == ActiveToolType.rotate) {
        num rotateFactor = 1.0;

        currentItem.matrix.rotateX(deltaMoveX * rotateFactor);
        currentItem.matrix.rotateY(deltaMoveY * rotateFactor);
        currentItem.matrix.rotateY(deltaMoveZ * rotateFactor);
      }

      if (activeTool == ActiveToolType.scale) {
        num scaleFactor = 0.03;

        currentItem.matrix.scale( 1.0 + deltaMoveX * scaleFactor, 1.0 + deltaMoveY * scaleFactor, 1.0 + deltaMoveZ * scaleFactor,);
      }
    }
  }
}
