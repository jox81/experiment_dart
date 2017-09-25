import '../known_types.dart';
import 'state_controller_common.dart';

class MainController extends StateController{

  List<Type> dataNeeded = [Paytable, Stake, Character];

  MainController();
}
