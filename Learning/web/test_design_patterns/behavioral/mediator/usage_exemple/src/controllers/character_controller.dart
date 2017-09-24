import '../known_types.dart';
import '../services/character_service.dart';
import 'state_controller_common.dart';

class CharacterController extends StateController {
  CharacterController();

  Character _data = CharacterService.data;

  @override
  dynamic reply(Type requestType) {
    dynamic replyValue;

    switch (requestType) {
      case Character:
        replyValue = _data;
        break;
      default:
        break;
    }

    return replyValue;
  }
}
