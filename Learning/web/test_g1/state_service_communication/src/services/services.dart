import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../known_types.dart';


abstract class ServiceAware{
  StreamController dataChangeController = new StreamController();
  Stream get onChange => dataChangeController.stream;

  OnResponse(_data){
    dataChangeController.add(_data);
  }
}


abstract class Service{

  int data;

  void update() {
    sleep(const Duration(seconds:1));
    OnResponse(new Random().nextInt(20));
  }

  OnResponse(_data){
    data = _data;
  }
}

class CharacterService extends Service with ServiceAware{
  static Character get characterData => new Character();

  Future update()async {
    await super.update();
  }

}

class PaytableService extends Service with ServiceAware{
  static Paytable get paytableData => new Paytable();
}