import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/interaction/interactionnable.dart';

abstract class CameraControllerInteraction implements Interactionable{
  CameraController get cameraController;
}