import 'controllers/help_controller.dart';
import 'controllers/main_controller.dart';
import 'controllers/character_controller.dart';
import 'dart:async';
import 'controllers/state_controller_common.dart';
import 'interfaces/state_interfaces.dart';
import 'known_types.dart';

class StateManager extends IStateManager{

  static List<Type> _knownTypes;
  static List<Type> get knownTypes => _knownTypes;

  Set<IStateController> _stateControllers = new Set();
  Set<IStateController> get stateControllers => _stateControllers;

  StateManager(){
    _knownTypes = clientKnownTypes;

    _initControllers();
  }

  void _initControllers() {
    StateController mainSlot = new MainController();
    StateController help = new HelpController();
    StateController map = new CharacterController();

    for (StateController newStateController in [mainSlot, map, help]) {
    }
  }

  Future play() async {

  }
}