import '../interfaces/state_interfaces.dart';
import '../state_manager.dart';
import 'dart:async';
import 'dart:math';

abstract class StateController extends IStateController{

  Completer requestCompleter;

  StreamController<RequestFromStateController>  _requestController = new StreamController();
  @override
  Stream<RequestFromStateController> get onRequests => _requestController.stream;

  @override
  Future play() async {
    //..

    //Need infos, request other states...
    Type requestType = StateManager.knownTypes[new Random().nextInt(StateManager.knownTypes.length)];
    dynamic replyValue = await makeRequest(requestType);

    //Verify replyValue
    if(replyValue == null){
      throw new Exception('Nobody can repond to this request...');
    }
    assert(replyValue.runtimeType == requestType);

    print('$this asked for value : $replyValue, ok !');
  }

  @override
  Future<dynamic> makeRequest(Type neededType) {
    requestCompleter = new Completer();
    print('$this request $neededType');
    RequestFromStateController request = new RequestFromStateController(this, neededType);
    _requestController.add(request);
    return requestCompleter.future;
  }

  @override
  bool handleResponse(ResponseToStateController responsefromStateController) {
    requestCompleter.complete(responsefromStateController.value);
    return true;
  }
}