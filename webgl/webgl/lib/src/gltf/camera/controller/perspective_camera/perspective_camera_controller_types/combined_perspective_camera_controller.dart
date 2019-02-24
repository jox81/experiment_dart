import 'dart:html';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller_types/fly_perspective_camera_controller.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller_types/orbit_perspective_camera_controller.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller_types/pan_perspective_camera_controlle.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller_types/rotate_perspective_camera_controller.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/interaction/interactionnable.dart';

/// Ce controller interactionable sert à modifier le type de controller de la camera via le clavier
/// Il ne doit pas être ajouté sur une camera, mais directement en tant qu'interactionnable
/// Todo (jpu) : pouvoir l'ajouter en tant que controller de base de la camera ?
class CombinedPerspectiveCameraController implements Interactionable{

  OrbitPerspectiveCameraController _orbitPerspectiveCameraController;
  RotatePerspectiveCameraController _rotatePerspectiveCameraController;
  PanPerspectiveCameraController _panPerspectiveCameraController;
  FlyPerspectiveCameraController _flyPerspectiveCameraController;

  CombinedPerspectiveCameraController(){
    _orbitPerspectiveCameraController = new OrbitPerspectiveCameraController(useKeyboard: false);
    _rotatePerspectiveCameraController = new RotatePerspectiveCameraController();
    _panPerspectiveCameraController = new PanPerspectiveCameraController();
    _flyPerspectiveCameraController = new FlyPerspectiveCameraController();
  }

  @override
  void onKeyPressed(List<bool> currentlyPressedKeys) {
    // Todo (jpu) : replace this
    if(currentlyPressedKeys[KeyCode.ONE]) Engine.mainCamera.cameraController = _orbitPerspectiveCameraController;
    if(currentlyPressedKeys[KeyCode.TWO]) Engine.mainCamera.cameraController = _rotatePerspectiveCameraController;
    if(currentlyPressedKeys[KeyCode.THREE]) Engine.mainCamera.cameraController = _panPerspectiveCameraController;
    if(currentlyPressedKeys[KeyCode.FOUR]) Engine.mainCamera.cameraController = _flyPerspectiveCameraController;
  }

  @override
  void onMouseDown(int screenX, int screenY) {

  }

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) {
    // TODO: implement onMouseMove
  }

  @override
  void onMouseUp(int screenX, int screenY) {
    // TODO: implement onMouseUp
  }

  @override
  void onMouseWheel(num deltaY) {
    // TODO: implement onMouseWheel
  }

  @override
  void onTouchEnd(int screenX, int screenY) {
    // TODO: implement onTouchEnd
  }

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange}) {
    // TODO: implement onTouchMove
  }

  @override
  void onTouchStart(int screenX, int screenY) {
    // TODO: implement onTouchStart
  }
}