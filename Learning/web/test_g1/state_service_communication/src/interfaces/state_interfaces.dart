import 'dart:async';

abstract class IStateManager{

  Set<IStateController> get stateControllers;

  Future play();
}

abstract class IStateController{
  Future play();
}