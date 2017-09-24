import 'dart:async';

abstract class IStateManager{

  Set<IStateController> get stateControllers;

  Future play();
  void register(IStateController stateController);
  Future handleRequest(RequestFromStateController request);
}

abstract class IStateController{
  Stream<RequestFromStateController> get onRequests;//emit a request

  Future play();
  Future<dynamic> makeRequest(Type neededType);
  bool handleResponse(dynamic replyValue);//handle the response requested
  dynamic reply(Type requestType) => null;//reply if can reply to requestType
}

class RequestFromStateController {
  final IStateController requesterStateController;
  final Type requestType;

  RequestFromStateController(this.requesterStateController, this.requestType);
}

class ResponseToStateController {
  final IStateController responderStateController;
  final dynamic value;

  ResponseToStateController(this.responderStateController, this.value);
}
