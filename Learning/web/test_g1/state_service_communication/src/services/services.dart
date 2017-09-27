import 'dart:async';
import 'dart:math';
import '../known_types.dart';

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

abstract class ServiceAware{
  StreamController dataChangeController = new StreamController.broadcast();
  Stream get onChange => dataChangeController.stream;

  //tell the type of data it can give
  List<Type> dataToGive;

  Future update();
}

class CharacterService extends Service with ServiceAware{

  List<Type> dataToGive = [Character];

  OnResponse(_data){
    super.OnResponse(_data);
    dataChangeController.add('CharacterService update his data : $_data');
  }

}

class PaytableService extends Service with ServiceAware{

  List<Type> dataToGive = [Paytable, Stake];

  OnResponse(_data){
    super.OnResponse(_data);
    dataChangeController.add('PaytableService update his data : $_data');
  }
}