import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/interaction/interactionnable.dart';
import 'package:webgl/src/project/project_debugger.dart';

abstract class Project{
  List<Interactionable> _interactionables = new List<Interactionable>();
  List<Interactionable> get interactionables => _interactionables;

  ProjectDebugger get projectDebugger;

  Project(){
    Engine.currentProject = this;
  }

  void addInteractable(Interactionable customInteractionable) {
    _interactionables.add(customInteractionable);
  }

  debug({bool doProjectLog:false, bool isDebug:false}) {
    projectDebugger.debug(this, doProjectLog: doProjectLog, isDebug: isDebug);
  }
}