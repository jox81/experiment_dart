import 'dart:async';

/// Exemple using Command Design Pattern
/// Based on http://www.dofactory.com/net/command-design-pattern
///
/// Encapsulate a request as an object, thereby letting you parameterize clients
/// with different requests, queue or log requests, and support undoable operations.
Future main() async {

  // The client create receiver, command, and invoker
  Receiver receiver = new Receiver();
  Command command = new ConcreteCommand(receiver);


  // Set and execute command
  Invoker invoker = new Invoker();
  invoker.SetCommand(command);
  invoker.ExecuteCommand();
}

/// The 'Command' abstract class
abstract class Command {
  Receiver receiver;

  // Constructor
  Command(Receiver receiver) {
    this.receiver = receiver;
  }

  void Execute();
}

/// The 'ConcreteCommand' class
class ConcreteCommand extends Command {
// Constructor
  ConcreteCommand(Receiver receiver) : super(receiver) {}

  @override
  void Execute() {
    receiver.Action();
  }
}

/// The 'Receiver' class
class Receiver {
  void Action() {
    print("Called Receiver.Action()");
  }
}

/// The 'Invoker' class
class Invoker {
  Command _command;

  void SetCommand(Command command) {
    this._command = command;
  }

  void ExecuteCommand() {
    _command.Execute();
  }
}
