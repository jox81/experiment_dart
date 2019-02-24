import 'package:webgl/src/camera/controller/camera_controller.dart';
import 'package:vector_math/vector_math.dart';

abstract class Camera{
  CameraController cameraController;

  Matrix4 get projectionMatrix;
  Matrix4 get viewMatrix;

  Vector3 get translation;
  set translation(Vector3 value);

  void update() {}
  
  bool _isActive = false;
  bool get isActive => _isActive;
  set isActive(bool value) {
    _isActive = value;
  }
}