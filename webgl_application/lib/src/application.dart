import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/utils_geometry.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/context.dart' hide gl;
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

enum AxisType { view, x, y, z, any }
enum ActiveToolType { select, move, rotate, scale }

class Application implements Interactable, ToolBarAxis, ToolBarTool, IUpdatableScene{
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

  GLTFRenderer renderer;
  GLTFProject project;
  CameraPerspective get mainCamera => Context.mainCamera;

  GLTFNode tempSelection;
  // TODO: implement interaction
  @override
  Interaction get interaction => renderer.interaction;

  Application._(CanvasElement canvas){
    renderer = new GLTFRenderer(canvas);
    initInteraction();
  }

  void render() {
    renderer.render(project);
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

  @override
  void initInteraction(){
    interaction.onMouseDown.listen(_onMouseDownHandler);
    interaction.onMouseUp.listen(_onMouseUpHandler);
    interaction.onDrag.listen(_onDragHandler);
    interaction.onResize.listen((dynamic event){Context.resizeCanvas();});
  }

  void _onMouseDownHandler(MouseEvent event) {
    if (Context.mainCamera != null) {
      GLTFNode modelHit = UtilsGeometry.findNodeFromMouseCoords(
          Context.mainCamera, event.offset.x, event.offset.y,
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

    if(currentSelection != null && currentSelection is GLTFNode) {

      GLTFNode currentItem = currentSelection as GLTFNode;

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
