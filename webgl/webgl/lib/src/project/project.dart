import 'package:webgl/src/interaction/interactionnable.dart';

abstract class Project{
  List<Interactionable> _interactionables = new List<Interactionable>();
  List<Interactionable> get interactionables => _interactionables;

  void addInteractable(Interactionable customInteractionable) {
    _interactionables.add(customInteractionable);
  }
}