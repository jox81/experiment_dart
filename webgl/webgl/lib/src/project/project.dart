import 'dart:html';

import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller_types/combined_perspective_camera_controller.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/interaction/custom_interactionable.dart';
import 'package:webgl/src/interaction/interactionnable.dart';
import 'package:webgl/src/project/project_debugger.dart';

abstract class Project{
  List<Interactionable> _interactionables = new List<Interactionable>();
  List<Interactionable> get interactionables => _interactionables;

  ProjectDebugger get projectDebugger => null;// Todo (jpu) : optionnal
  CanvasElement get canvas => Engine.currentEngine.canvas;

  Camera _mainCamera;
  Camera get mainCamera => _mainCamera;
  set mainCamera(Camera value){
    _mainCamera?.isActive = false;
    _mainCamera = value;
    _mainCamera.isActive = true;
    _mainCamera?.update();
  }

  Project(){
    Engine.currentProject = this;

    addInteractable(new CustomInteractionable(() => Engine.mainCamera?.cameraController));
    addInteractable(new CombinedPerspectiveCameraController());
  }

  void addInteractable(Interactionable customInteractionable) {
    _interactionables.add(customInteractionable);
  }

  debug({bool doProjectLog:false, bool isDebug:false}) {
    projectDebugger.debug(this, doProjectLog: doProjectLog, isDebug: isDebug);
  }

  void update({num currentTime : 0.0}) {}
}