import 'dart:async';
import 'src/state_manager.dart';

/// Exemple using kind of Mediator Design Pattern
/// Based on http://www.dofactory.com/net/mediator-design-pattern
Future main() async {
  StateManager stateManager = new StateManager();
  await stateManager.play();
}


