import 'dart:async';

import '../known_types.dart';
import '../services/services.dart';
import 'state_controller_common.dart';

class MapController extends StateController {

  CharacterService serviceCharacter = new CharacterService();

  MapController(){
    serviceCharacter.onChange.listen(updateCharacter);
  }

  @override
  Future play() async {
    serviceCharacter.update();
  }

  void updateCharacter(Character event) {
    print('the $this was updated with data : ($event)');
  }
}
