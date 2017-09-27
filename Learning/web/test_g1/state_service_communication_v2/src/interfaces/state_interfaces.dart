import 'dart:async';
import '../controllers/state_controller_common.dart';

abstract class IStateManager{

  Set<StateController> get stateControllers;

  Future play();
}