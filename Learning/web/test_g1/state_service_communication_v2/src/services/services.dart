import 'dart:async';
import 'dart:math';
import '../known_types.dart';

abstract class Service{

  var serverData;

  var data;

  Future update() async {
    OnResponse(serverData);
  }

  OnResponse(_data){
    data = _data;
  }
}

abstract class ServiceAware{
  StreamController dataChangeController = new StreamController.broadcast();
  Stream get onChange => dataChangeController.stream;
}

class CharacterService extends Service with ServiceAware{

  //
  get serverData => new Character();

  //>
  static final CharacterService _singleton = new CharacterService._internal();
  factory CharacterService() {
    return _singleton;
  }

  CharacterService._internal() {
    //... // initialization logic here
  }
  //<

  OnResponse(_data){
    super.OnResponse(_data);
    dataChangeController.add(data);
  }
}

class PaytableService extends Service with ServiceAware{

  //
  get serverData => new Paytable();

  //>
  static final PaytableService _singleton = new PaytableService._internal();
  factory PaytableService() {
    return _singleton;
  }

  PaytableService._internal() {
    //... // initialization logic here
  }
  //<

  OnResponse(_data){
    super.OnResponse(_data);
    dataChangeController.add(data);
  }
}