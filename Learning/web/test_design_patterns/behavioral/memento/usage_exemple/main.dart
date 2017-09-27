import 'dart:async';

/// Exemple using Visitor Design Pattern
/// Based on http://www.dofactory.com/net/visitor-design-pattern
///
/// Represent an operation to be performed on the elements of an object structure.
/// Visitor lets you define a new operation without changing the classes of the elements on which it operates.
///
/// This real-world code demonstrates the Memento pattern which temporarily
/// saves and then restores the SalesProspect's internal state.
Future main() async {
  SalesProspect s = new SalesProspect();
  s.name = "Noel van Halen";
  s.phone = "(412) 256-0990";
  s.budget = 25000.0;

  // Store internal state
  ProspectMemory m = new ProspectMemory();
  m.memento = s.SaveMemento();

  // Continue changing originator
  s.name = "Leo Welch";
  s.phone = "(310) 209-7111";
  s.budget = 1000000.0;

  // Restore saved state
  s.RestoreMemento(m.memento);
}

/// The 'Originator' class
class SalesProspect
{
  String _name;
  String _phone;
  double _budget;

  String get name => _name;
  set name(String value) {
    _name = value;
    print("name:  " + _name);
  }

  String get phone => _phone;
  set phone(String value) {
    _phone = value;
    print("phone:  " + _name);
  }

  double get budget => _budget;
  set budget(double value) {
    _budget = value;
    print("budget:  " + _name);
  }

  // Stores memento
  Memento SaveMemento()
  {
    print("\nSaving state --\n");
    return new Memento(_name, _phone, _budget);
  }

  // Restores memento
  void RestoreMemento(Memento memento)
  {
    print("\nRestoring state --\n");
    this.name = memento.name;
    this.phone = memento.phone;
    this.budget = memento.budget;
  }
}

/// The 'Memento' class
class Memento
{
  String _name;
  String _phone;
  double _budget;

  // Constructor
  Memento(String name, String phone, double budget)
  {
    this._name = name;
    this._phone = phone;
    this._budget = budget;
  }

  double get budget => _budget;
  set budget(double value) {
    _budget = value;
  }

  String get phone => _phone;
  set phone(String value) {
    _phone = value;
  }

  String get name => _name;
  set name(String value) {
    _name = value;
  }

}

/// The 'Caretaker' class
class ProspectMemory
{
  Memento _memento;

  Memento get memento => _memento;
  set memento(Memento value) {
    _memento = value;
  }
}
 