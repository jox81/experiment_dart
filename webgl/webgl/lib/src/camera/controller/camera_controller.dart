import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/interaction/controller/controller.dart';
import 'package:webgl/src/interaction/interactionnable.dart';

abstract class CameraController extends Controller implements Interactionable{
  Camera get camera;
  set camera(Camera camera);
  void init(){}
  void updateCameraTransformWithKeys(List<bool> currentlyPressedKeys);
}