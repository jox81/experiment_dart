import 'controllers/help_controller.dart';
import 'controllers/main_controller.dart';
import 'controllers/character_controller.dart';
import 'dart:async';
import 'controllers/state_controller_common.dart';
import 'interfaces/state_interfaces.dart';
import 'known_types.dart';
import 'services/services.dart';

class StateManager extends IStateManager{

  static List<Type> _knownTypes;
  static List<Type> get knownTypes => _knownTypes;

  Set<IStateController> _stateControllers = new Set();
  Set<IStateController> get stateControllers => _stateControllers;

  Set<ServiceAware> _services = new Set();
  Set<ServiceAware> get services => _services;

  StateManager(){
    _knownTypes = clientKnownTypes;

    _initServices();
    _initControllers();
    _combineControllersWithServices();
  }

  void _initServices() {
    Service characterService = new CharacterService();
    Service paytableService = new PaytableService();

    for (Service service in [characterService, paytableService]) {
      _services.add(service);
    }
  }

  void _initControllers() {
    StateController mainSlot = new MainController();
    StateController help = new HelpController();
    StateController map = new CharacterController();

    for (StateController stateController in [mainSlot, map, help]) {
      _stateControllers.add(stateController);
    }
  }

  void _combineControllersWithServices() {
    //On prend chaque controller
    for (StateController stateController in _stateControllers) {

      //on passe en revue chaque data needed
      for (Type t in stateController.dataNeeded){

        //on cherche les services qui propose ces datas
        List services = _services.where((s)=> s.dataToGive.contains(t)).toList();

        //on abonne le sateController au service
        for (ServiceAware service in services) {
          service.onChange.listen((e)=> _notify(e, stateController));
        }
      }
    }
  }

  Future play() async {
    for (ServiceAware service in services) {
      service.update();
    }
  }

  void _notify(event, StateController stateController) {
    print('');
    print('notify : $event > updating $stateController');
    stateController.update(event);
  }
}