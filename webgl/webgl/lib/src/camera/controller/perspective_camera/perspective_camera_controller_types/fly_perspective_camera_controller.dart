import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/controller/perspective_camera/perspective_camera_controller.dart';

class FlyPerspectiveCameraController extends PerspectiveCameraController{

  double _startFov;

  FlyPerspectiveCameraController();

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

  void updateFovWithKeys(List<bool> currentlyPressedKeys) {
    num fovAmplitude = 0.01;
    if (currentlyPressedKeys[KeyCode.NUM_MINUS]) {
      updateFov(fovAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.NUM_PLUS]) {
      updateFov(-fovAmplitude);
    }
  }

  void updateCameraTransformWithKeys(List<bool> currentlyPressedKeys) {
    //move
    double moveAmplitude = 0.1;
    Vector3 moveDelta = new Vector3.zero();

    // front
    if (currentlyPressedKeys[KeyCode.NUM_EIGHT]) {
      moveDelta += new Vector3(0.0, 0.0, moveAmplitude);
    }
    // rear
    if (currentlyPressedKeys[KeyCode.NUM_TWO]) {
      moveDelta += new Vector3(0.0, 0.0, -moveAmplitude);
    }
    //left
    if (currentlyPressedKeys[KeyCode.NUM_FOUR]) {
      moveDelta += new Vector3(-moveAmplitude, 0.0, 0.0);
    }
    //right
    if (currentlyPressedKeys[KeyCode.NUM_SIX]) {
      moveDelta += new Vector3(moveAmplitude, 0.0, 0.0);
    }

    //up
    if (currentlyPressedKeys[KeyCode.NUM_FIVE]) {
      moveDelta += new Vector3(0.0, -moveAmplitude, 0.0);
    }
    //down
    if (currentlyPressedKeys[KeyCode.NUM_ZERO]) {
      moveDelta += new Vector3(0.0, moveAmplitude, 0.0);
    }

    if(moveDelta != new Vector3.zero()) {
      if (camera.isActive) {
        move(moveDelta);
      }
    }
  }

  void updateCameraTransform(double deltaX, double deltaY) {
    if (camera.isActive && isDragging) {
      rotateView(deltaX, deltaY);
    }
  }

  /// Pour faire une rotation de la vue, on déplace la target
  void rotateView(num xAngleRot, num yAngleRot) {
    Vector3 rotateViewDirection = camera.frontDirection;
    rotateViewDirection.applyAxisAngle(camera.upDirection, radians(xAngleRot.toDouble()));
    rotateViewDirection.applyAxisAngle(camera.frontDirection.cross(camera.upDirection), radians(yAngleRot.toDouble()));
    camera.targetPosition = camera.translation + rotateViewDirection;
  }

  void move(Vector3 moveDelta) {
    camera.translation += camera.xAxis.normalized() * moveDelta.x;
    camera.translation += camera.yAxis.normalized() * moveDelta.y;
    camera.translation += camera.zAxis.normalized() * moveDelta.z;
    camera.targetPosition += camera.xAxis.normalized() * moveDelta.x;
    camera.targetPosition += camera.yAxis.normalized() * moveDelta.y;
    camera.targetPosition += camera.zAxis.normalized() * moveDelta.z;
  }
}
