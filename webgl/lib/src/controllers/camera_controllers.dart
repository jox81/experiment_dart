import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';

class CameraController {
  num xRot = 0.0;
  num yRot = 0.0;
  num scaleFactor = 3.0;
  bool dragging = false;
  int currentX = 0;
  int currentY = 0;
  double deltaX = 0.0;
  double deltaY = 0.0;

  //WheelEvent values
  double fov = radians(45.0);

  CameraController();

  CameraPerspective _camera;

  void init(CameraPerspective camera) {
    _camera = camera;
    xRot = 90 - camera.pitch;
    yRot = camera.phiAngle;
  }

  void updateCamerFov(CameraPerspective camera, num deltaY){
    if (camera.isActive) {
      changeCameraFov(camera, deltaY);
    }
  }

  void updateCameraPosition(CameraPerspective camera,double deltaX, double deltaY, int buttonType){
    if (camera.isActive) {
      if (dragging) {

        if (buttonType == 0) {
          //LMB
          doOrbit(deltaX, deltaY);

        } else if (buttonType == 1) {
          //MMB
          deltaX *= 0.5;
          deltaY *= 0.5;
          pan(deltaX, deltaY);
        }
      }
    }
  }

  /// Update the X and Y rotation angles based on the mouse motion.
  void doOrbit(num deltaX, num deltaY) {
    //LMB
    // Update the X and Y rotation angles based on the mouse motion.
    yRot = (yRot + deltaX) % 360;
    xRot = (xRot + deltaY);

    // Clamp the X rotation to prevent the camera from going upside down.
    if (xRot < -90) {
      xRot = -90;
    } else if (xRot > 90) {
      xRot = 90;
    }

    //Todo : create first person eye Rotation with ctrl key
    rotateOrbit(yRot, xRot); //why inverted ?
  }

  void beginOrbit(Camera camera, int screenX, int screenY) {
    dragging = true;
  }

  void endOrbit(Camera camera) {
    dragging = false;
  }

  void changeCameraFov(CameraPerspective camera, num deltaY) {
    var delta = Math.max(-1, Math.min(1, deltaY));
    fov += delta / 100; //calcul du zoom

    camera.yfov = fov;
  }

  void rotateOrbit(num xAngleRot, num yAngleRot) {
    num distance = _camera.frontDirection
        .length; // Straight line distance between the camera and look at point

    // Calculate the camera position using the distance and angles
    double camX = _camera.targetPosition.x +
        distance *
            -Math.sin(xAngleRot * (Math.pi / 180)) *
            Math.cos((yAngleRot) * (Math.pi / 180));
    double camY = _camera.targetPosition.y +
        distance * -Math.sin((yAngleRot) * (Math.pi / 180));
    double camZ = _camera.targetPosition.z +
        -distance *
            Math.cos((xAngleRot) * (Math.pi / 180)) *
            Math.cos((yAngleRot) * (Math.pi / 180));

    _camera.translation = _camera.translation..setValues(camX, camY, camZ);
  }

  void pan(double deltaX, double deltaY) {
    _camera.translation += _camera.xAxis * deltaX;
    _camera.translation += _camera.yAxis * deltaY;
    _camera.targetPosition += _camera.xAxis * deltaX;
    _camera.targetPosition += _camera.yAxis * deltaY;
  }
}
