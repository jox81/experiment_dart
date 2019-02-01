import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/interaction/interactionnable.dart';

abstract class Project{
  List<Interactionable> _interactionables = new List<Interactionable>();
  List<Interactionable> get interactionables => _interactionables;

  Project(){
    Engine.currentProject = this;
  }

  void addInteractable(Interactionable customInteractionable) {
    _interactionables.add(customInteractionable);
  }
}