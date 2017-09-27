import 'dart:async';

import '../known_types.dart';
import '../services/services.dart';
import 'state_controller_common.dart';

class MainController extends StateController{

  PaytableService servicePaytable = new PaytableService();
  CharacterService serviceCharacter = new CharacterService();

  MainController(){
    serviceCharacter.onChange.listen(updateCharacter);
    servicePaytable.onChange.listen(updatePaytable);
  }

  @override
  Future play() async {
    servicePaytable.update();
    serviceCharacter.update();
  }

  void updateCharacter(Character event) {
    print('the $this was updated with data : ($event)');
  }

  void updatePaytable(Paytable event) {
    print('the $this was updated with data : ($event)');
  }
}
