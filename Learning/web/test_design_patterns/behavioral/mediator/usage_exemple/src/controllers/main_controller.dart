import '../known_types.dart';
import 'state_controller_common.dart';

class MainController extends StateController{
  MainController();

  Paytable _dataPaytable = new Paytable();
  Paytable replyPaytable() {
    return _dataPaytable;
  }

  Stake _dataStake = new Stake();
  Stake replyStake() {
    return _dataStake;
  }

  @override
  dynamic reply(Type requestType) {
    dynamic replyValue;

    switch (requestType) {
      case Paytable:
          replyValue = replyPaytable();
        break;
      case Stake:
          replyValue = replyStake();
        break;
      default:
        break;
    }

    return replyValue;
  }
}
