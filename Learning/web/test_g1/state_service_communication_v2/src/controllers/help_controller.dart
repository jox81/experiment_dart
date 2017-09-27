import '../known_types.dart';
import '../services/services.dart';
import 'state_controller_common.dart';

class HelpController extends StateController {

  PaytableService servicePaytable = new PaytableService();

  HelpController(){
    servicePaytable.onChange.listen(updatePaytable);
  }

  void updatePaytable(Paytable event) {
    print('the $this was updated with data : ($event)');
  }
}
