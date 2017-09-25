import 'dart:async';
import 'dart:math';
import '../known_types.dart';

abstract class ServiceAware extends Service{
  StreamController dataChangeController = new StreamController.broadcast();
  Stream get onChange => dataChangeController.stream;

  //tell it can give some type of data
  List<Type> dataToGive;
}

abstract class Service{

  int data;

  Future update() async {
    await new Future.delayed(const Duration(seconds: 1), () => "1");
    OnResponse(new Random().nextInt(20));
  }

  OnResponse(_data){
    data = _data;
  }
}

class CharacterService extends Service with ServiceAware{
  static Character get characterData => new Character();

  List<Type> dataToGive = [Character];

  OnResponse(_data){
    super.OnResponse(_data);
    dataChangeController.add('CharacterService update his data : $_data');
  }

}

class PaytableService extends Service with ServiceAware{
  static Paytable get paytableData => new Paytable();

  List<Type> dataToGive = [Paytable, Stake];

  OnResponse(_data){
    super.OnResponse(_data);
    dataChangeController.add('PaytableService update his data : $_data');
  }
}