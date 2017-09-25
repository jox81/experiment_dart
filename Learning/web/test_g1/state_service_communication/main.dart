import 'dart:async';
import 'src/services/services.dart';
import 'src/state_manager.dart';

/// Exemple using kind of Mediator Design Pattern
/// Based on http://www.dofactory.com/net/mediator-design-pattern
Future main() async {
//  StateManager stateManager = new StateManager();
//  await stateManager.play();

  Service s = new CharacterService();
  s.update();
}


