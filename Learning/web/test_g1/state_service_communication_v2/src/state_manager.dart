import 'controllers/help_controller.dart';
import 'controllers/main_controller.dart';
import 'controllers/map_controller.dart';
import 'dart:async';
import 'controllers/state_controller_common.dart';
import 'interfaces/state_interfaces.dart';

class StateManager extends IStateManager{

  Set<StateController> _stateControllers = new Set();
  Set<StateController> get stateControllers => _stateControllers;

  StateController currentController;

  StateManager(){
    _initControllers();
  }

  void _initControllers() {
    StateController map = new MapController();
    StateController mainSlot = new MainController();
    StateController help = new HelpController();

    for (StateController stateController in [mainSlot, map, help]) {
      _stateControllers.add(stateController);
    }

    currentController = mainSlot;
  }

  Future play() async {
    currentController.play();
  }
}