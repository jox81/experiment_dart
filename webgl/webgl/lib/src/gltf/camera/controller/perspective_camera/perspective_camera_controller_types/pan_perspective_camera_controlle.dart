import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller.dart';

class PanPerspectiveCameraController extends PerspectiveCameraController{

  double _startFov;

  PanPerspectiveCameraController();

  ///Mouse

  @override
  void onMouseDown(int screenX, int screenY) {
    beginTransform();
  }

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) {
    updateCameraTransform(deltaX, deltaY);
  }

  @override
  void onMouseUp(int screenX, int screenY) {
    endTransform();
  }

  @override
  void onMouseWheel(num deltaY) {
    updateFov(deltaY);
  }

  ///Touch

  @override
  void onTouchStart(int screenX, int screenY) {
    if(screenX == null && screenY == null){
      _startFov = camera.yfov;
    }else {
      beginTransform();
    }
  }

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange : 1.0}) {
    if(deltaX == null && deltaY == null){
      //fov
      updateFov(_startFov / scaleChange);
    }else {
      updateCameraTransform(deltaX, deltaY);
    }
  }

  @override
  void onTouchEnd(int screenX, int screenY) {
    endTransform();
    _startFov = null;
  }

  ///Keyboard

  @override
  void onKeyPressed(List<bool> currentlyPressedKeys) {
    updateCameraTransformWithKeys(currentlyPressedKeys);
    updateFovWithKeys(currentlyPressedKeys);
  }

  @override
  void updateFovWithKeys(List<bool> currentlyPressedKeys) {
    num fovAmplitude = 0.01;
    if (currentlyPressedKeys[KeyCode.NUM_MINUS]) {
      updateFov(fovAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.NUM_PLUS]) {
      updateFov(-fovAmplitude);
    }
  }

  @override
  void updateCameraTransformWithKeys(List<bool> currentlyPressedKeys) {
    double panAmplitude = 5.0;
    Vector2 direction = new Vector2.zero();

    if (currentlyPressedKeys[KeyCode.UP]) {
      direction += new Vector2(0.0, panAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.DOWN]) {
      direction += new Vector2(0.0, -panAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.LEFT]) {
      direction += new Vector2(panAmplitude, 0.0);
    }
    if (currentlyPressedKeys[KeyCode.RIGHT]) {
      direction += new Vector2(-panAmplitude, 0.0);
    }

    if(direction != new Vector2.zero()) {
      if (camera.isActive) {
          beginTransform();
          updateCameraTransform(direction.x, direction.y);
          endTransform();
      }
    }
  }

  void updateCameraTransform(double deltaX, double deltaY) {
    if (camera.isActive && isDragging) {
      pan(deltaX, deltaY);
    }
  }

  void pan(double deltaX, double deltaY, {num panScale = 0.05}) {
    deltaX *= panScale;
    deltaY *= panScale;
    camera.translation += camera.xAxis * deltaX;
    camera.translation += camera.yAxis * deltaY;
    camera.targetPosition += camera.xAxis * deltaX;
    camera.targetPosition += camera.yAxis * deltaY;
  }
}
