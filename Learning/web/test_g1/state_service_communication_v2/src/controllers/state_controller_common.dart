import 'dart:async';

abstract class StateController{

  Future play(){
    //...
    return new Future.value();
  }

  update(data){
    print('the $this was updated with data : ($data)');
  }
}