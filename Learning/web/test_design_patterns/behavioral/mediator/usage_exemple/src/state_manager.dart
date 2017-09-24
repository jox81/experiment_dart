import 'controllers/help_controller.dart';
import 'controllers/main_controller.dart';
import 'controllers/character_controller.dart';
import 'dart:async';
import 'controllers/state_controller_common.dart';
import 'interfaces/state_interfaces.dart';
import 'known_types.dart';

class StateManager extends IStateManager{

  //> test values to check how many times other replies
  int playCount = 10;
  int _otherReplyCount = 0;
  //<

  static List<Type> _knownTypes;
  static List<Type> get knownTypes => _knownTypes;

  Set<IStateController> _stateControllers = new Set();
  Set<IStateController> get stateControllers => _stateControllers;

  StateManager(){
    _knownTypes = clientKnownTypes;

    _initControllers();
  }

  void _initControllers() {
    StateController mainSlot = new MainController();
    StateController help = new HelpController();
    StateController map = new CharacterController();

    for (StateController newStateController in [mainSlot, map, help]) {
      register(newStateController);
    }
  }

  Future play() async {
    print('');
    print('>> otherReplyCount : $_otherReplyCount');
    IStateController nextStateController = _getRandomStateController();
    await nextStateController.play();

    if (_otherReplyCount <= playCount) {
      await play();
    }
  }

  IStateController _getRandomStateController() {
    IStateController nextStateController =
        (stateControllers.toList()..shuffle()).first;
    return nextStateController;
  }

  @override
  Future handleRequest(RequestFromStateController eventRequest) async {
    ResponseToStateController response = _findResponseFromStates(eventRequest.requestType);
    _sendReponse(eventRequest.requesterStateController, response);
  }

  ///Is there someone who can respond to the request?
  ResponseToStateController _findResponseFromStates(Type requestType){
    IStateController stateControllerReplier;
    dynamic replyValue;

    //as soon as we have a value, we continue
    for (IStateController stateController in stateControllers.toList()
      ..shuffle()) {
      replyValue = stateController.reply(requestType);
      if (replyValue != null) {
        stateControllerReplier = stateController;
        break;
      }
    }

    return new ResponseToStateController(stateControllerReplier, replyValue);
  }

  bool _sendReponse(IStateController requestingStateController, ResponseToStateController response){
    bool isHandledCorrectly =
    requestingStateController.handleResponse(response);
    _otherReplyCount++;
    print(
        '${response.responderStateController} replies to ${requestingStateController}');
    return isHandledCorrectly;
  }

  @override
  void register(IStateController newStateController) {
    stateControllers.add(newStateController);
    ///Hey new one, if you have a request, I listen to you
    newStateController.onRequests.listen(handleRequest);
  }
}