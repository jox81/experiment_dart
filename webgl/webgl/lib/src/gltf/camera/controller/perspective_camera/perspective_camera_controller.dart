import 'package:webgl/src/camera/controller/camera_controller.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';

abstract class PerspectiveCameraController extends CameraController{
  bool _isDragging = false;
  bool get isDragging => _isDragging;

  GLTFCameraPerspective _camera;
  @override
  GLTFCameraPerspective get camera => _camera;
  @override
  set camera(covariant GLTFCameraPerspective value) {
    _camera = value;
  }

  PerspectiveCameraController();

  void updateFovWithKeys(List<bool> currentlyPressedKeys);

  void updateFov(num deltaY) {
    if (camera.isActive) {
      camera.yfov += deltaY;
    }
  }

  void beginTransform() {
    _isDragging = true;
  }

  void endTransform() {
    _isDragging = false;
  }
}
