import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller.dart';

class OrbitPerspectiveCameraController extends PerspectiveCameraController{

  final bool useKeyboard;

  double _startFov;
  num xRot = 0.0;
  num yRot = 0.0;

  OrbitPerspectiveCameraController({this.useKeyboard = true});

  @override
  void init() {
    xRot = 90 - camera.pitch;
    yRot = camera.phiAngle;
  }

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
    if(useKeyboard) {
      updateCameraTransformWithKeys(currentlyPressedKeys);
      updateFovWithKeys(currentlyPressedKeys);
    }
  }

  @override
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
    double orbitAmplitude = 1.0;
    Vector2 direction = new Vector2.zero();

    if (currentlyPressedKeys[KeyCode.UP]) {
      direction += new Vector2(0.0, -orbitAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.DOWN]) {
      direction += new Vector2(0.0, orbitAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.LEFT]) {
      direction += new Vector2(-orbitAmplitude, 0.0);
    }
    if (currentlyPressedKeys[KeyCode.RIGHT]) {
      direction += new Vector2(orbitAmplitude, 0.0);
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
      doOrbit(deltaX, deltaY);
    }
  }

  /// Update the X and Y rotation angles based on the mouse motion.
  void doOrbit(num deltaX, num deltaY) {
    // LMB
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
    rotateOrbit(yRot, xRot); // Todo (jpu) : why inverted ?
  }

  void rotateOrbit(num xAngleRot, num yAngleRot) {
    num distance = camera.frontDirection
        .length; // Straight line distance between the camera and look at point

    // Calculate the new camera position using the distance and angles
    double camX = camera.targetPosition.x +
        distance *
            -Math.sin(xAngleRot * (Math.pi / 180)) *
            Math.cos((yAngleRot) * (Math.pi / 180));
    double camY = camera.targetPosition.y +
        distance * -Math.sin((yAngleRot) * (Math.pi / 180));
    double camZ = camera.targetPosition.z +
        -distance *
            Math.cos((xAngleRot) * (Math.pi / 180)) *
            Math.cos((yAngleRot) * (Math.pi / 180));

    camera.translation = camera.translation..setValues(camX, camY, camZ);
  }
}
