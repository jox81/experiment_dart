import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/controllers/camera_controller_mode.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/interaction/camera_controller_interaction.dart';
import 'package:webgl/src/interaction/orbit_camera_controller_interaction.dart';
import 'package:webgl/src/interaction/pan_camera_controller_interaction.dart';
import 'package:webgl/src/interaction/rotate_camera_controller_interaction.dart';

class BaseCameraController implements CameraController{
  final Vector3 upAxis = new Vector3(0.0, 1.0, 0.0);

  CameraControllerMode _cameraControllerMode;

  CameraPerspective _camera;
  CameraPerspective get camera => _camera;

  num xRot = 0.0;
  num yRot = 0.0;
  num scaleFactor = 3.0;
  bool dragging = false;
  int currentX = 0;
  int currentY = 0;
  double deltaX = 0.0;
  double deltaY = 0.0;

  @override
  CameraControllerInteraction get cameraControllerInteraction => _currentCameraControllerInteraction;
  CameraControllerInteraction _currentCameraControllerInteraction;

  OrbitCameraControllerInteraction _orbitCameraControllerInteraction;
  RotateCameraControllerInteraction _rotateCameraControllerInteraction;
  PanCameraControllerInteraction _panCameraControllerInteraction;

  double get yfov => _camera.yfov;

  BaseCameraController(){
    _orbitCameraControllerInteraction = new OrbitCameraControllerInteraction(this);
    _rotateCameraControllerInteraction = new RotateCameraControllerInteraction(this);
    _panCameraControllerInteraction = new PanCameraControllerInteraction(this);

    _currentCameraControllerInteraction = _orbitCameraControllerInteraction;
    _cameraControllerMode = CameraControllerMode.orbit;
  }

  void init(covariant CameraPerspective camera) {
    _camera = camera;
    xRot = 90 - camera.pitch;
    yRot = camera.phiAngle;
  }

  void updateCameraFov(num deltaY) {
    if (_camera.isActive) {
      _camera.yfov += deltaY;
    }
  }

  void toggleInteraction(CameraControllerMode mode){
    _cameraControllerMode = mode;
    switch(mode){
      case CameraControllerMode.orbit:
        _currentCameraControllerInteraction = _orbitCameraControllerInteraction;
        break;
      case CameraControllerMode.rotate:
        _currentCameraControllerInteraction = _rotateCameraControllerInteraction;
        break;
      case CameraControllerMode.pan:
        _currentCameraControllerInteraction = _panCameraControllerInteraction;
        break;
    }
  }

  void updateCameraPosition(double deltaX, double deltaY) {
    if (_camera.isActive) {
      if (dragging) {
        if(_cameraControllerMode == null) throw 'cameraControllerMode must be set just before using this commande';
        if (_cameraControllerMode == CameraControllerMode.orbit) {
          doOrbit(deltaX, deltaY);
        } else if (_cameraControllerMode == CameraControllerMode.rotate) {
          rotateView(-deltaX,deltaY);
        }else if (_cameraControllerMode == CameraControllerMode.pan) {
          pan(deltaX, deltaY);
        }
      }
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

  void beginOrbit() {
    dragging = true;
  }

  void endOrbit() {
    dragging = false;
  }

  void rotateOrbit(num xAngleRot, num yAngleRot) {
    num distance = _camera.frontDirection
        .length; // Straight line distance between the camera and look at point

    // Calculate the new camera position using the distance and angles
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


  num _rotateViewYaw = 0;
  num _rotateViewPitch = 0;
  /// Pour faire une rotation de la vue, on déplace la target
  void rotateView(num xAngleRot, num yAngleRot) {
    Vector3 rotateViewDirection = new Vector3(0.0, 0.0, 1.0);
    _rotateViewYaw -= xAngleRot;
    _rotateViewPitch -= yAngleRot;
    rotateViewDirection.applyQuaternion(Quaternion.euler(radians(_rotateViewYaw.toDouble()), radians(_rotateViewPitch.toDouble()), 0));
    _camera.targetPosition = _camera.translation + rotateViewDirection;
  }

  void pan(double deltaX, double deltaY, {num panScale = 0.05}) {
    deltaX *= panScale;
    deltaY *= panScale;
    _camera.translation += _camera.xAxis * deltaX;
    _camera.translation += _camera.yAxis * deltaY;
    _camera.targetPosition += _camera.xAxis * deltaX;
    _camera.targetPosition += _camera.yAxis * deltaY;
  }
}
