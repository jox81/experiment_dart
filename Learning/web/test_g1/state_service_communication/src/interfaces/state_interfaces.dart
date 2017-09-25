import 'dart:async';

abstract class IStateManager{

  Set<IStateController> get stateControllers;

  Future play();
}

abstract class IStateController{

  List<Type> dataNeeded;

  Future play();

  update(data){
    print('the $this was updated with data : ($data)');
  }

  //tell it need some type of data
}