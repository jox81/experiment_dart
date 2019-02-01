import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/interaction/interactionnable.dart';

abstract class Project{
  List<Interactionable> _interactionables = new List<Interactionable>();
  List<Interactionable> get interactionables => _interactionables;

  Camera _mainCamera;
  Camera get mainCamera => _mainCamera;
  set mainCamera(Camera value) {
    _mainCamera?.isActive = false;
    _mainCamera = value;
    _mainCamera.isActive = true;
    Context.glWrapper.resizeCanvas();
  }

  Project(){
    Engine.currentProject = this;

    _mainCamera = new
    CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);
  }

  void addInteractable(Interactionable customInteractionable) {
    _interactionables.add(customInteractionable);
  }
}