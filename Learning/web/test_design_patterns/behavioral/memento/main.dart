import 'dart:async';

/// Exemple using Memento Design Pattern
/// Based on http://www.dofactory.com/net/memento-design-pattern
///
/// Without violating encapsulation, capture and externalize an object's internal
/// state so that the object can be restored to this state later.
///
/// This structural code demonstrates the Memento pattern which temporary saves
/// and restores another object's internal state.
Future main() async {
  Originator o = new Originator();
  o.state = "On";

  // Store internal state
  Caretaker c = new Caretaker();
  c.memento = o.CreateMemento();

  // Continue changing originator
  o.state = "Off";

  // Restore saved state
  o.SetMemento(c.memento);
}

/// The 'Originator' class
class Originator
{
  String _state;
  String get state => _state;
  set state(String value) {
    _state = value;
    print("State = " + _state);
  }

  // Creates memento
  Memento CreateMemento()
  {
    return (new Memento(_state));
  }

  // Restores original state
  void SetMemento(Memento memento)
  {
    print("Restoring state...");
    state = memento.state;
  }
}

/// The 'Memento' class
class Memento
{
  String _state;

  // Constructor
  Memento(String state)
  {
    this._state = state;
  }

  String get state => _state;
}

/// The 'Caretaker' class
class Caretaker
{
  Memento _memento;
  Memento get memento => _memento;
  set memento(Memento value) {
    _memento = value;
  }
}
