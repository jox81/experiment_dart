import 'dart:async';

/// Exemple using Command Design Pattern
/// Based on http://www.dofactory.com/net/command-design-pattern
///
/// This real-world code demonstrates the Command pattern used in a simple calculator
/// with unlimited number of undo's and redo's.
Future main() async {
  // Create user and let her compute
  User user = new User();

  // User presses calculator buttons
  user.Compute('+', 100);
  user.Compute('-', 50);
  user.Compute('*', 10);
  user.Compute('/', 2);

  // Undo 4 commands
  user.Undo(4);

  // Redo 3 commands
  user.Redo(3);
}

/// The 'Command' abstract class
abstract class Command {
  void Execute();
  void UnExecute();
}

/// The 'ConcreteCommand' class
class CalculatorCommand extends Command {
  String _operator;
  int _operand;
  Calculator _calculator;

// Constructor
  CalculatorCommand(Calculator calculator, String operator, int operand) {
    this._calculator = calculator;
    this._operator = operator;
    this._operand = operand;
  }

// Gets operator
  set Operator(String value) {
    _operator = value;
  }

// Get operand
  set Operand(int value) {
    _operand = value;
  }

// Execute new command
  void Execute() {
    _calculator.Operation(_operator, _operand);
  }

// Unexecute last command
  void UnExecute() {
    _calculator.Operation(Undo(_operator), _operand);
  }

// Returns opposite operator for given operator
  String Undo(String operator) {
    switch (operator) {
      case '+':
        return '-';
      case '-':
        return '+';
      case '*':
        return '/';
      case '/':
        return '*';
      default:
        throw new Exception("operator");
    }
  }
}

/// The 'Receiver' class
class Calculator {
  num _curr = 0;

  void Operation(String operator, num operand) {
    switch (operator) {
      case '+':
        _curr += operand;
        break;
      case '-':
        _curr -= operand;
        break;
      case '*':
        _curr *= operand;
        break;
      case '/':
        _curr /= operand;
        break;
    }
    print("Current value : ${_curr.toStringAsFixed(2)} = (following $operator $operand)");
  }
}

/// The 'Invoker' class
class User {
  // Initializers
  Calculator _calculator = new Calculator();
  List<Command> _commands = new List<Command>();
  int _current = 0;

  void Redo(int levels) {
    print("\n---- Redo ${levels} levels ");
    // Perform redo operations
    for (int i = 0; i < levels; i++) {
      if (_current < _commands.length - 1) {
        Command command = _commands[_current++];
        command.Execute();
      }
    }
  }

  void Undo(int levels) {
    print("\n---- Undo ${levels} levels ");
    // Perform undo operations
    for (int i = 0; i < levels; i++) {
      if (_current > 0) {
        Command command = _commands[--_current];
        command.UnExecute();
      }
    }
  }

  void Compute(String operator, int operand) {
    // Create command operation and execute it
    Command command = new CalculatorCommand(_calculator, operator, operand);
    command.Execute();

    // Add command to undo list
    _commands.add(command);
    _current++;
  }
}
