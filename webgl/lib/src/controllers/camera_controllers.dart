import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/interaction/camera_controller_interaction.dart';

abstract class CameraController{
  CameraControllerInteraction get cameraControllerInteraction;
  Camera get camera;
  void init(Camera camera);
}